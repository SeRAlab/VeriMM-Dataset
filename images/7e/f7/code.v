module top_module(
    output reg X,
    input wire A,
    input wire B,
    input wire C,
    input wire D,
    input wire VPWR,
    input wire VGND,
    input wire VPB,
    input wire VNB
);wire or_output;
    
    // Simple four-input OR gate implementation
    assign or_output = A | B | C | D;

    always @ (or_output) begin
        X = or_output;
    end

endmodule