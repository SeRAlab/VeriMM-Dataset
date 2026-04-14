module top_module(clk, addr, we, din, dout);parameter  DATA_WIDTH = 8;
    parameter  ADDR_WIDTH = 8;
    localparam RAM_DEPTH  = 1 << ADDR_WIDTH;
    input  clk;
    input  [(ADDR_WIDTH-1):0] addr;
    input  we;
    input  [(DATA_WIDTH-1):0] din;
    output [(DATA_WIDTH-1):0] dout;

    reg [(DATA_WIDTH-1):0] ram [0:(RAM_DEPTH-1)];

    assign dout = ram[addr];

    always @(posedge clk) begin
        if (we) begin
            ram[addr] <= din;
        end
    end

endmodule