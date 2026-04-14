module top_module(
    CLK,
    RST_N,
    read_0,
    write_0,
    EN_write_0,
    read_1,
    write_1,
    EN_write_1
);parameter            DATA_SZ = 1;
    parameter            RESET_VAL = 0;

    input                CLK;
    input                RST_N;
    output [DATA_SZ-1:0] read_0;
    input  [DATA_SZ-1:0] write_0;
    input                EN_write_0;
    output [DATA_SZ-1:0] read_1;
    input  [DATA_SZ-1:0] write_1;
    input                EN_write_1;

    reg    [DATA_SZ-1:0] r;
    wire   [DATA_SZ-1:0] wire_0;
    wire   [DATA_SZ-1:0] wire_1;
    wire   [DATA_SZ-1:0] wire_2;

    assign wire_0 = r;
    assign wire_1 = EN_write_0 ? write_0 : wire_0;
    assign wire_2 = EN_write_1 ? write_1 : wire_1;

    assign read_0 = wire_0;
    assign read_1 = wire_1;

    always @(posedge CLK) begin
        if (RST_N == 0) begin
            r <= RESET_VAL;
        end else begin
            r <= wire_2;
        end
    end
endmodule