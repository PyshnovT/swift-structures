#include <stdio.h>
#include <stdlib.h>
#include "linked_list.c"

void print_list(node_t *head) {
    node_t *tmp = head;

    while (tmp != NULL) {
        printf("%d - ", tmp->value);
        tmp = tmp->next;
    }
    
}

int main() {
    node_t *head = NULL;
    node_t *tmp;
    
    for (int i = 0; i < 25; i++) {
        tmp = create_new_node(i);
        insert_at_head(&head, tmp);
    }

    tmp = find_node(head, 14);
    printf("found node with value %d\n", tmp->value);
    insert_after_node(tmp, create_new_node(100));
    print_list(head);
    
    return 0;
}
