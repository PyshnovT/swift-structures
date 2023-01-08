#include <stdio.h>

#include <stdlib.h>

typedef struct {
    int value;
    struct node* next;
} node_t;

node_t * 
create_new_node(int value) {
    node_t *result = malloc(sizeof(node_t));
    result->value = value;
    result->next = NULL;
    return result;
}

node_t *
insert_at_head(node_t **head, node_t * node_to_insert) {
    node_to_insert->next = *head;
    *head = node_to_insert;
    return node_to_insert;
}

node_t *
find_node(node_t *head, int value) {
    node_t *tmp = head;
    while (tmp != NULL) {
        if (tmp->value == value) return tmp;
        tmp = tmp->next;
    }
    return NULL;
}

void
insert_after_node(node_t *node_to_insert_after, node_t *new_node) {
    new_node->next = node_to_insert_after->next;
    node_to_insert_after->next = new_node;
}
