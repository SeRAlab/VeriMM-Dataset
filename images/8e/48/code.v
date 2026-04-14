module top_module(D, Y, _IN_ERR);input   [3:0]   D;
    output  [1:0]   Y;
    output          _IN_ERR;
    
    wire    [1:0]   Y;
    wire            _IN_ERR;

    assign Y[1] = D[3] | D[2];
    assign Y[0] = D[3] | D[1];
    assign _IN_ERR = (~D[3] | D[2] | D[1] | D[0]) & (D[3] | ~D[2] | D[1] | D[0]) & (D[3] | D[2] | ~D[1] | D[0]) & (D[3] | D[2] | D[1] | ~D[0]);

endmodule