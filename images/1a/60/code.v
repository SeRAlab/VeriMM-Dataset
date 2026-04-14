module dr_cell (
    input wire [7:0] data_in,
    input wire we,  // Write enable
    input wire re,  // Read enable
    input wire clk,
    output reg [7:0] data_out
);
    reg [7:0] mem;

    always @(posedge clk) begin
        if (we) begin
            mem <= data_in;  // Write data to memory
        end
        if (re) begin
            data_out <= mem;  // Read data from memory
        end
    end
endmodule