module top_module(
    input  clk,
    input  d,
    output reg q,  // Changed to reg type to hold state
    input  scd,
    input  sce
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // Removed the instantiation of the non-existent module
    // sky130_fd_sc_hs__sdfxtp_4 base (
    //     .CLK(clk),
    //     .D(d),
    //     .Q(q),
    //     .SCD(scd),
    //     .SCE(sce)
    // );

    always @(posedge clk) begin
        if (sce) begin
            q <= d;  // Assign d to q on sce
        end 
        else if (scd) begin
            q <= 0;  // Reset q to 0 on scd
        end
    end

endmodule