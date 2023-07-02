import React from 'react'

import NoPayType from './NoPayType'
import CreditCardPayType from './CreditCardPayType'
import CheckPayType from './CheckPayType'
import PurchaseOrderPayType from './PurchaseOrderPayType'

class PayTypeSelector extends React.Component {
  constructor (props){
    super(props)
    this.onPayTypeSelected = this.onPayTypeSelected.bind(this)
    this.state = { selectedPayType: null }
  }

  onPayTypeSelected(event) {
    this.setState({ selectedPayType: event.target.value })
  }

  render() {
    let PayTypeCustomComponent = NoPayType
    if (this.state.selectedPayType == '1') {
      PayTypeCustomComponent = CheckPayType
    } else if (this.state.selectedPayType == '2') {
      PayTypeCustomComponent = CreditCardPayType
    } else if (this.state.selectedPayType == '3') {
      PayTypeCustomComponent = PurchaseOrderPayType
    }

    return (
      <div>
        <div className="field">
          <label htmlFor="order_pay_type_id">Pay type</label>
          <select onChange={this.onPayTypeSelected} name="order[pay_type_id]" id="order_pay_type_id">
            <option value="">Select a payment method</option>
            <option value="1">Check</option>
            <option value="2">Credit card</option>
            <option value="3">Purchase order</option>
          </select>

          <PayTypeCustomComponent />
        </div>
      </div>
    )
  }
}

export default PayTypeSelector
