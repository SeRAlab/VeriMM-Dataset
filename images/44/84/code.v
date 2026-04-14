module top_module(input wire X, input wire A, output reg [31:0] count);reg prev_X;
    integer transition_count;

    initial begin
        prev_X = 1'b0;       // Initialize prev_X
        transition_count = 0; // Initialize transition count to 0
    end
    
    always @(posedge X) begin
        if (prev_X == 1'b0 && X == 1'b1) begin
            transition_count = transition_count + 1;
        end
        prev_X = X;
    end
    
    always @(posedge A) begin
        if (A == 1'b1) begin
            count = transition_count;
        end
    end
endmodule