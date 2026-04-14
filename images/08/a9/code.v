module gpio_controller (
    input clk,
    input rst,
    input [4:0] dir,       // Direction register (5 bits)
    input [4:0] data_in,   // Data input (5 bits)
    input [4:0] data_out_en, // Data output enable (5 bits)
    output reg [4:0] data_out, // Data output (5 bits)
    output reg [4:0] data_in_read // Data input read (5 bits)
);

reg [4:0] direction; // Direction register

always @(posedge clk or posedge rst) begin
    if (rst) begin
        direction <= 5'b00000;
        data_out <= 5'b00000;
        data_in_read <= 5'b00000;
    end else begin
        direction <= dir; // Update direction
        data_out <= (direction & data_out_en) | (data_out & ~data_out_en); // Set output based on direction
        data_in_read <= data_in & ~direction; // Read input only if configured as input
    end
end

endmodule