import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { patch } from "@rails/request.js"


export default class extends Controller {
  static values = { status: String }


  connect(){

    console.log("connected")
    console.log(typeof Sortable)
    
    this.sortable = Sortable.create(this.element, {
      group: "kanban",
      animation: 100,
      onEnd: this.onEnd.bind(this)
      })
    }

  async onEnd(event) {
    const { item, to } = event

    const taskId = item.dataset.id
    const modelName = item.dataset.model
    const newStatus = to.dataset.kanbanStatusValue

    console.log({ taskId, newStatus })

    const url = `/${modelName}/${taskId}/update_status`

    const response = await patch(url, {
      body: { status: newStatus },
      contentType: "application/json",
      responseKind: "json"
    })

  if (!response.ok) {
    alert("保存に失敗しました。ページを再読み込みします")
    window.location.reload()
  }
}
}


