module top_module(
    output reg VPWR,
    output reg VGND
);// Initialize outputs
    initial begin
        VPWR = 1; // Set VPWR to 1V
        VGND = 0; // Set VGND to 0V
    end

endmodule