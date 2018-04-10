import UIKit
import Marshroute

public final class PhotoLibraryV2MarshrouteAssemblyImpl: BasePaparazzoAssembly, PhotoLibraryV2MarshrouteAssembly {
    
    typealias AssemblyFactory = MediaPickerMarshrouteAssemblyFactory
    
    private let assemblyFactory: AssemblyFactory
    
    init(assemblyFactory: AssemblyFactory, theme: PaparazzoUITheme, serviceFactory: ServiceFactory) {
        self.assemblyFactory = assemblyFactory
        super.init(theme: theme, serviceFactory: serviceFactory)
    }
    
    public func module(
        selectedItems: [PhotoLibraryItem],
        maxSelectedItemsCount: Int?,
        routerSeed: RouterSeed,
        configure: (PhotoLibraryV2Module) -> ()
    ) -> UIViewController {
        
        let photoLibraryItemsService = PhotoLibraryItemsServiceImpl()
        
        let interactor = PhotoLibraryV2InteractorImpl(
            selectedItems: selectedItems,
            maxSelectedItemsCount: maxSelectedItemsCount,
            photoLibraryItemsService: photoLibraryItemsService,
            cameraService: serviceFactory.cameraService(initialActiveCameraType: .back)
        )
        
        let router = PhotoLibraryV2MarshrouteRouter(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let presenter = PhotoLibraryV2Presenter(
            interactor: interactor,
            router: router
        )
        
        let viewController = PhotoLibraryV2ViewController()
        viewController.addDisposable(presenter)
        viewController.setTheme(theme)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
