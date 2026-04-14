module top_module(
    clock_2x,
    reset,
    dequeue_in,
    dequeue_out
);parameter N = 1;
    
    input           clock_2x;
    input           reset;
    input   [N-1:0] dequeue_in;
    output  [N-1:0] dequeue_out;
    
    reg dequeue_cycle;
    
    always @(posedge clock_2x or posedge reset)
    begin
        if (reset)
            dequeue_cycle = 1'b0;
        else
            dequeue_cycle = ~dequeue_cycle;
    end
    
    assign dequeue_out = {(N){dequeue_cycle}} & dequeue_in;
endmodule