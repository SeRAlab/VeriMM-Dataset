module top_module(
    input  VPWR,
    input  UDP_IN,
    input  CLK,
    output UDP_OUT
);reg pwrgood;

    always @(posedge CLK) begin
        if (UDP_IN) begin
            pwrgood <= 0;
        end else begin
            pwrgood <= VPWR;
        end
    end

    assign UDP_OUT = pwrgood;

endmodule