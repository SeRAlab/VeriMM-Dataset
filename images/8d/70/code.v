module top_module(
    input A,
    output reg Z,
    input clock
);// Remove the sky130_fd_sc_hdll__einvn_1 instance since it is undefined
    // and is causing compilation errors.

    always @(posedge clock) begin
        Z <= ~A; // Keep the functionality to invert A on clock edge
    end

endmodule