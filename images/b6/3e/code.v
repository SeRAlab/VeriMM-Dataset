module top_module(
    input clk,
    input [7:0] din,
    output reg [7:0] dout
);reg [7:0] ram [0:63];
    reg [5:0] addr1, addr2;
    reg [1:0] read_en;
    reg write_en;

    always @(posedge clk) begin
        if (write_en) begin
            ram[addr1] <= din;
        end
        if (read_en[0]) begin
            dout <= ram[addr2];
        end
        if (read_en[1]) begin
            dout <= ram[addr2];
        end
    end

    always @* begin
        addr1 = din[5:0];
        addr2 = {din[5:0], 1'b0};
        read_en = din[6:5];
        write_en = din[7];
    end

endmodule