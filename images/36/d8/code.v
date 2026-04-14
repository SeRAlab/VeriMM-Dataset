module down_counter (
    input clk,
    input rst,
    input [3:0] init_value,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= init_value; // Load initial value on reset
        end else if (count > 0) begin
            count <= count - 1; // Decrement the count
        end
    end
endmodule