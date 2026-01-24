// Import and register all your controllers from importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Register Marksmith controllers
import { MarksmithController, ListContinuationController } from '@avo-hq/marksmith'
application.register('marksmith', MarksmithController)
application.register('list-continuation', ListContinuationController)

// Auto-load other controllers
eagerLoadControllersFrom("controllers", application)