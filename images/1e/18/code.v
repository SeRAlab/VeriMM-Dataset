module gpio_controller (
    input wire clk,
    input wire wr_en,
    input wire rd_en,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);

// State to hold last written value
reg [4:0] last_written;

always @(posedge clk) begin
    if (wr_en) begin
        last_written <= data_in; // Update last written value
    end
    if (rd_en) begin
        data_out <= last_written; // Output last written value
    end
end

endmodule