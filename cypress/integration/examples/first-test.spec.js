/// <reference types="cypress" />

// const url = 'http://localhost:8080'
const url = 'https://stopsopa.github.io/cypress-research'

context('First tests', () => {

  // beforeEach(() => {
  //   cy.visit('https://example.cypress.io/commands/actions')
  // })

  it('Hello Cypress', () => {

    cy.visit(`${url}/index.html`)

    cy.contains('Hello Cypress')

    cy.get('input')
      .type('getparam')
      .should('have.value', 'getparam')

    cy.get('a').click();

    cy.url().should('include', '?url=getparam');
  })
})
