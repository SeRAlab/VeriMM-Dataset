module down_counter (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [3:0] load_value,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Asynchronous reset to zero
        end else if (load) begin
            count <= load_value; // Load the counter with the specified value
        end else if (count > 4'b0000) begin
            count <= count - 1; // Decrement the counter
        end
    end
endmodule