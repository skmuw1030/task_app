import { Controller } from "@hotwired/stimulus"
import * as Sortable from "sortablejs"
import { patch } from "@rails/request.js"


export default class extends Controller {
  static values = { status: String }


  connect(){
    this.sortable = Sortable.default.create(this.element, {
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

    

    const url = `/${modelName}/${taskId}/update_status`

    const response = await patch(url, {
      body: { status: newStatus },
      contentType: "application/json",
      responseKind: "json"
    })

  if (response.ok) {

    if (newStatus === "完了"){
      const rect = item.getBoundingClientRect()

      const x = (rect.left + rect.width / 2) / window.innerWidth
      const y = (rect.top + rect.height / 2) / window.innerHeight
      confetti({
        particleCount: 40,
        spread: 20,
        drift: -1,
        origin: {
          x: x,
          y: y
        }
      })
    }

    setTimeout(() => {
      window.location.reload()
    }, 500)
  }


  if (!response.ok) {
    alert("保存に失敗しました。ページを再読み込みします")
    window.location.reload()
  }
}
}


