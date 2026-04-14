module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input select,     // Select input to choose between counter and RAM
    output [3:0] q,   // 4-bit output from the active module
    input write_en,   // Write enable for the RAM
    input [2:0] write_addr, // Write address for the RAM
    input [3:0] write_data, // Write data for the RAM
    input read_en,    // Read enable for the RAM
    input [2:0] read_addr,  // Read address for the RAM
    output reg [3:0] read_data // 4-bit output from the RAM
);reg [3:0] counter;
reg [3:0] ram [0:7];

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
    end else if (select) begin
        counter <= counter + 1;
    end else begin
        if (write_en) begin
            ram[write_addr] <= write_data;
        end
        if (read_en) begin
            read_data <= ram[read_addr];
        end
    end
end

assign q = select ? counter : read_data;

endmodule