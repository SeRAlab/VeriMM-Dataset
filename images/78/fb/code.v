module top_module(
    input [3:0] A,
    input [3:0] B,
    output gt,
    output lt,
    output eq
);wire [3:0] diff;
    
    assign diff = A - B;
    
    assign gt = (diff[3] == 1) ? 1'b1 : 1'b0;
    assign lt = (diff[3] == 0) && (diff != 0) ? 1'b1 : 1'b0;
    assign eq = (diff == 0) ? 1'b1 : 1'b0;

endmodule