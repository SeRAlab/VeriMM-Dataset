module down_counter (
    input clk,
    input rst_n,
    input load,
    input [3:0] load_value,
    output reg [3:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000; // Reset the counter to 0
        end else if (load) begin
            count <= load_value; // Load the new value
        end else if (count > 0) begin
            count <= count - 1; // Decrement the counter
        end
    end
endmodule