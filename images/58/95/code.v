module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    input enable,     // Asynchronous counter enable
    input [3:0] A,    // 4-bit input for the adder-subtractor circuit
    input [3:0] B,    // 4-bit input for the adder-subtractor circuit
    input sub,        // Selects between addition and subtraction
    input select,     // Selects between counter and adder-subtractor circuit output
    output [3:0] Q    // Final output from the active module
);// Counter module with asynchronous reset and enable
    reg [3:0] counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
        end else if (enable) begin
            counter <= counter + 1;
        end
    end
    
    // Adder-subtractor module
    wire [3:0] sum;
    assign sum = sub ? A - B : A + B;
    
    // Functional module to select maximum value
    reg [3:0] max_value;
    always @(*) begin
        if (select) begin
            max_value = counter > sum ? counter : sum;
        end else begin
            max_value = counter;
        end
    end
    
    // Output
    assign Q = max_value;
    
endmodule