import UIKit

public final class PhotoLibraryV2AssemblyImpl: BasePaparazzoAssembly, PhotoLibraryV2Assembly {
    
    typealias AssemblyFactory = MediaPickerAssemblyFactory
    
    private let assemblyFactory: AssemblyFactory
    
    init(assemblyFactory: AssemblyFactory, theme: PaparazzoUITheme, serviceFactory: ServiceFactory) {
        self.assemblyFactory = assemblyFactory
        super.init(theme: theme, serviceFactory: serviceFactory)
    }
    
    public func module(
        data: PhotoLibraryV2Data,
        configure: (PhotoLibraryV2Module) -> ())
        -> UIViewController
    {
        let photoLibraryItemsService = PhotoLibraryItemsServiceImpl()
        
        let interactor = PhotoLibraryV2InteractorImpl(
            selectedItems: data.selectedItems,
            maxSelectedItemsCount: data.maxSelectedItemsCount,
            photoLibraryItemsService: photoLibraryItemsService,
            cameraService: serviceFactory.cameraService(initialActiveCameraType: .back)
        )
        
        let viewController = PhotoLibraryV2ViewController()
        
        let router = PhotoLibraryV2UIKitRouter(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = PhotoLibraryV2Presenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        viewController.setTheme(theme)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
