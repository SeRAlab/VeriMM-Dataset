module top_module(
    input rst,
    input clk,
    input ie,
    input de,
    input [31:0] iaddr,
    input [31:0] daddr,
    input [1:0] drw,
    input [31:0] din,
    input [7:0] switches,
    output [31:0] iout,
    output [31:0] dout
);reg [31:0] idata, ddata; // Change wire to reg for idata and ddata
    
    assign iout = ie ? idata : 32'hzzzzzzzz;
    assign dout = de && (drw == 2'b01) ? ddata : 32'hzzzzzzzz;

    reg [31:0] mem [0:2**32-1];

    always @(posedge clk) begin
        if (rst) begin
            idata <= 32'h00000000;
            ddata <= {24'h000000, switches};
        end else begin
            if (ie) begin
                idata <= mem[iaddr];
            end
            if (de) begin
                case (drw)
                    2'b10: mem[daddr] <= din;
                    2'b01: ddata <= mem[daddr];
                endcase
            end
        end
    end
endmodule