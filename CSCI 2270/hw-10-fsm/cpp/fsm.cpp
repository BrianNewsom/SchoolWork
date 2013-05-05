/*

  fsm.cpp - Finite State Machine

  Read the header file 'fsm.hpp' for all documentation on individual
  functions. I suggest you start by getting the unit test cases to
  pass in order. E.g. start with the Defaults one, then do Add States,
  and so on.

  Your Name: Brian Newsom

  Your Collaborators:

 */

#include "fsm.hpp"

using namespace std;

FSM::FSM() {
  state = -1;
  default_state = -1;
  // implement me
  
}

int FSM::addState(string label, bool is_accept_state) {
  int id = states.size();
  State* st = new State;
  st->label = label;
  st->accept = is_accept_state;
  st->failure_trans = -1;
  states.push_back(st);
  if ( id == 0){
    default_state = 0;
    state = 0;
  }

  return id;
}

int FSM::addState(string label) {
  return addState(label, false);
}

int FSM::addTransition(int stateA, int stateB, 
		       int signal, string transLabel) {
  if (stateA < 0 || stateB < 0)
    return -1;
  State* stA = states[stateA];
  State* stB = states[stateB];
  if (stA == NULL || stB == (NULL))
    return -1;
  /*  for(size_t i = 0 ; i < stA->trans.size() ; i++){
    cout << i << endl;
    if  (stA->trans[i] == transitions.size())
      return -1;
      }*/
  for (size_t i = 0 ; i < transitions.size() ; i++){
    if (transitions[i]->next_state == stateB)
      return -1;
  }
  Transition* tranny = new Transition;
  int trannyid = transitions.size();
  tranny->label = transLabel;
  tranny->signal = signal;
  tranny->next_state = stateB;
  transitions.push_back(tranny);

  stA->trans.push_back(trannyid);
  
  return trannyid;
}

int FSM::countStates() {
  // implement me
  return states.size();
}

int FSM::countTransitions() {
  // implement me
  return transitions.size();
}

int FSM::getCurrentState() {
  return state;
}

bool FSM::isAcceptState() {
  State* my_state = getState(this->state);
  if (my_state == NULL)
    {
      cout << "NULL" << endl;
      return false;
    }
  return my_state->accept;
}

State* FSM::getState(int id) {
  if( id < 0 || id >= states.size())
      return NULL;
  return states[id];
}

Transition* FSM::getTransition(int id) {
  if (id < 0 || id >= transitions.size())
    return NULL;
  return transitions[id];
}

int FSM::getDefaultState() {
  return default_state;

}

void FSM::setState(int id) {
  state = id;
  // implement me
}

bool FSM::handleSignal(int signal) {
  // implement me
  if (signal == 0 && states.empty())
    return false;
  int id = getCurrentState();
  State* st = states[id];
  //  if (transitions
  for (size_t i = 0; i < st->trans.size() ; i++){
    int temp = st->trans[i];
    Transition* tr = getTransition(temp);
    if (tr->signal == signal){
      setState(tr->next_state);
      cout << "STATE IS: " << getState(getCurrentState()) << endl;
      return true;
    }
  }
  if (st->failure_trans != -1){
    //setState(st->failure_trans);
    state = getTransition(st->failure_trans)->next_state;
    cout << "STATE IS: " << getState(getCurrentState()) << endl;
    return true;
  }
  //ssetState(FAILURE_SIGNAL);
  else
    return false;



}

ostream &operator << (ostream& out, State* st) {
  if (st == NULL) {
    out << "State: NULL";
  } else {
    out << "State: " << st->label;
    if (st->accept) {
      out << " +";
    }
  }
  return out;
}
