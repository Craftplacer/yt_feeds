function markUpdatedFeeds(lastTimeVisited) {
    const jsonElement = document.getElementById('feed-state-json');
    if (!jsonElement) {
        console.warn('feed-state-json not found');
        return;
    }

    const json = JSON.parse(jsonElement.innerText);
    const guideList = document.getElementsByClassName('guide-section')[0].getElementsByTagName('ul')[0];
    const listItems = guideList.getElementsByTagName('li');
    for (let i = 0; i < listItems.length; i++) {
        const item = listItems[i].getElementsByTagName('a')[0];
        const slug = item.getAttribute('data-slug');
        const lastTimeUpdated = Date.parse(json[slug]);
        console.debug(slug, lastTimeUpdated, lastTimeVisited);
        if (lastTimeUpdated > lastTimeVisited) {
            const span = document.createElement('span');
            span.className = 'guide-item-unread-badge';
            item.appendChild(span);
        }
    }
}

document.addEventListener('DOMContentLoaded', function () {
    let lastTimeVisited = window.localStorage.getItem('lastTimeVisited');
    if (lastTimeVisited) {
        const date = new Date(parseInt(lastTimeVisited));
        // date.setMonth(date.getMonth() - 1);
        markUpdatedFeeds(date);
    }
    window.localStorage.setItem('lastTimeVisited', Date.now().toString());
});