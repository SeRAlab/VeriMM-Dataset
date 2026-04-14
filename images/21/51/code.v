module dram_cell (
    input wire clk,
    input wire we,
    input wire [3:0] din,
    output reg [3:0] dout
);
    reg [3:0] storage; // internal storage for the DRAM cell

    always @(posedge clk) begin
        if (we) begin
            storage <= din; // write data to storage
        end
    end

    always @(*) begin
        dout = storage; // output the stored data
    end
endmodule