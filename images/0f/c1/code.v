module dram_cell (
    input wire clk,
    input wire we,
    input wire [15:0] din,
    output reg [15:0] dout
);
    reg [15:0] mem;

    always @(posedge clk) begin
        if (we) begin
            mem <= din; // Store data on write enable
        end
    end

    always @(*) begin
        dout = mem; // Output stored data
    end
endmodule