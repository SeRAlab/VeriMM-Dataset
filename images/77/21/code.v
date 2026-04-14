module top_module(
    input [3:0] a,
    input [3:0] b,
    input op,
    output [3:0] result
);reg [3:0] temp_result;
    
    always @(*) begin
        if (op == 0) // addition
            temp_result = a + b;
        else // subtraction
            temp_result = a - b;
    end
    
    assign result = temp_result;

endmodule