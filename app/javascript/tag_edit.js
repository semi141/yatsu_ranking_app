document.addEventListener("turbo:load", () => {
  const editBtn = document.getElementById("edit-tags-btn");
  const tagList = document.getElementById("tag-list");

  if (!editBtn || !tagList) return;

  // 編集モード ON/OFF
  editBtn.addEventListener("click", (e) => {
    e.preventDefault();
    tagList.classList.toggle("edit-mode");

    if (tagList.classList.contains("edit-mode")) {
      editBtn.textContent = "編集モード解除";
    } else {
      editBtn.textContent = "タグ編集モード";
    }
  });

  // バツ押したら削除
  tagList.addEventListener("click", (e) => {
    if (e.target.classList.contains("delete-btn")) {
      const tagItem = e.target.closest(".tag-item");
      const tagName = tagItem.dataset.tag;

      const videoId = window.location.pathname.split("/").pop();

      fetch(`/videos/${videoId}/remove_tag`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({ tag: tagName })
      }).then(() => {
        tagItem.remove();
      });
    }
  });
});
