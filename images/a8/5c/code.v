module top_module(
    input clk,
    input reset,
    input [3:0] input_1,
    input [3:0] input_2,
    output [3:0] final_output
);// First 4-bit adder with synchronous reset
    reg [3:0] adder1_out;
    always @(posedge clk) begin
        if (reset) begin
            adder1_out <= 4'b0;
        end else begin
            adder1_out <= input_1 + input_2;
        end
    end
    
    // Second 4-bit adder with synchronous reset
    reg [3:0] adder2_out;
    always @(posedge clk) begin
        if (reset) begin
            adder2_out <= 4'b0;
        end else begin
            adder2_out <= adder1_out + input_2;
        end
    end
    
    // Functional module that adds the outputs of both adders
    assign final_output = adder1_out + adder2_out;
    
endmodule