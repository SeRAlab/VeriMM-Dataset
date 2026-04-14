module top_module(
    aclr,
    datain_h,
    datain_l,
    outclock,
    dataout
);input aclr;
    input [0:0] datain_h;
    input [0:0] datain_l;
    input outclock;
    output [0:0] dataout;

    reg [0:0] delay_reg;

    always @(posedge outclock) begin
        if (aclr) begin
            delay_reg <= 1'b0;
        end
        else begin
            delay_reg <= {datain_h, datain_l};
        end
    end

    assign dataout = delay_reg[0];

endmodule