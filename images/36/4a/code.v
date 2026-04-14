module down_counter (
    input wire clk,
    input wire reset,
    input wire [3:0] load_value,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= load_value; // Load the starting value on reset
        end else if (count > 0) begin
            count <= count - 1; // Decrement the counter
        end
    end
endmodule