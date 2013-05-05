/**
 * LinkedList.java
 *
 * Consult the LinkedListInterface for method contracts.
 */
public class LinkedList implements LinkedListInterface {
    // It is up to you how this is implemented (aside from not being
    // able to use the standard Java collections or anything else)

    // I might suggest having some member variables here. All you need
    // is a single Node, but you can be fancy if you want.

    public Node initNode(int value) { 
    	Node newNode = new Node();
    	newNode.value = value;
    	return newNode;
    }
    
    public String report() {
	// implement me
	return null;
    }

    public void appendvalue(int value) {
	// implement me
    }

    public void append(Node node) {
	// implement me
    }

    public void insertvalue(int offset, int value) {
	// implement me
    }

    public void insert(int offset, Node node) {
	// implement me
    }

    public void remove(int offset) {
	// implement me
    }

    public int size() {
	// implement me
	return 0;
    }

    public boolean contains(int value) {
	// implement me
	return false;
    }

}
