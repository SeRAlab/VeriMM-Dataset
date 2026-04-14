module binary_multiplier(
    input [7:0] a,
    input [7:0] b,
    output [15:0] result
    );
    
    wire [15:0] temp_result;
    
    assign temp_result = {8'b0, a} * {8'b0, b};
    
    assign result = temp_result;
    
endmodule