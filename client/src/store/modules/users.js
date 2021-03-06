import usersApi from '../../api/users'
import auth from '../../auth'

const state = {
  current: null,
  byIds: {},
}

const getters = {
  findById (state) {
    return id => {
      const user = state.byIds[id]
      return {
        ...user,
        activated: !!user.username,
        displayedName: user.username || user.email,
        identifier: user.username || user.id,
        isLoggedIn: auth.isLoggedIn(),
        urlShow: '/dashboard',  // there is no user's profile page yet
      }
    }
  },

  current (state, getters) {
    const currentId = state.current
    if (currentId == null) {
      return null
    }
    return getters.findById(state.current)
  },
}

const actions = {
  register ({ commit }, email) {
    return usersApi.register(email)
      .then((res) => {
        auth.login(res.meta.token)
        commit('setCurrent', res.data)
      })
  },

  activate ({ commit }, { token, username, password }) {
    return usersApi.activate(token, username, password)
      .then((res) => {
        auth.login(res.meta.token)
        commit('setCurrent', res.data)
      })
  },

  login ({ commit }, { username, password }) {
    return usersApi.login(username, password)
      .then((res) => {
        auth.login(res.meta.token)
        commit('setCurrent', res.data)
      })
  },

  getCurrent ({ commit }) {
    return usersApi.getCurrent()
                   .then((res) => commit('setCurrent', res.data))
  },

  logout ({ commit }) {
    auth.logout()
    commit('reset')
    commit('tasks/reset', null, { root: true })
    commit('projects/reset', null, { root: true })
  },
}

const mutations = {
  setCurrent (state, data) {
    state.byIds = {
      ...state.byIds,
      [data.id]: {
        id: data.id,
        ...data.attributes,
      },
    }
    state.current = data.id
  },

  reset (state) {
    state.byIds = {}
    state.current = null
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
}
