// Import Stimulus
import { Application } from "@hotwired/stimulus";
const application = Application.start();
import PaginationController from "controllers/pagination_controller";
application.register("pagination", PaginationController);
