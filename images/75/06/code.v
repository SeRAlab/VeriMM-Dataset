module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    output [3:0] q,
    output reg [2:0] count_ones
);reg [3:0] counter;
    
    // Binary counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
        end else begin
            counter <= counter + 1;
        end
    end
    
    // Count the number of '1's in the binary representation of the count value
    always @(counter) begin
        count_ones <= {counter[0], counter[1], counter[2], counter[3]} 
                        - ((counter[0] & counter[1]) | (counter[0] & counter[2]) | (counter[0] & counter[3]) | (counter[1] & counter[2]) | (counter[1] & counter[3]) | (counter[2] & counter[3]));
    end
    
    assign q = counter;
    
endmodule