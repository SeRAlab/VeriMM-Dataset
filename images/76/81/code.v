module top_module(
    input clk,
    input [1:0] reset,
    input [1:0] ce,
    input ctrl,
    output [3:0] count1,
    output [3:0] count2,
    output [3:0] sum
);// Instantiate two 4-bit counters with asynchronous reset and clock enable inputs
    reg [3:0] counter1;
    reg [3:0] counter2;
    
    always @(posedge clk or negedge reset[0]) begin
        if (~reset[0]) begin
            counter1 <= 4'b0000;
        end else if (ce[0]) begin
            counter1 <= counter1 + 1;
        end
    end
    
    always @(posedge clk or negedge reset[1]) begin
        if (~reset[1]) begin
            counter2 <= 4'b0000;
        end else if (ce[1]) begin
            counter2 <= counter2 + 1;
        end
    end
    
    // Instantiate a functional module that adds the two counter outputs
    reg [3:0] counter_sum;
    
    always @(*) begin
        counter_sum = counter1 + counter2;
    end
    
    // Assign outputs
    assign count1 = counter1;
    assign count2 = counter2;
    assign sum = counter_sum;
    
endmodule