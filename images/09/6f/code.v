module down_counter (
    input clk,
    input rst,
    input load,
    input [3:0] load_value,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000; // Reset the counter to zero
        end else if (load) begin
            count <= load_value; // Load the initial value
        end else if (count > 0) begin
            count <= count - 1; // Count down
        end
    end
endmodule