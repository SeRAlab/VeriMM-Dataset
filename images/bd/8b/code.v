module top_module(
    input [3:0] D,
    input LD,
    input SR,
    input SL,
    output reg [3:0] Q
);always @ (posedge LD or posedge SR or posedge SL)
    begin
        if (LD)
            Q <= D;
        else if (SR)
            Q <= {Q[2:0], Q[3]}; // Rotate right
        else if (SL)
            Q <= {Q[0], Q[3:1]}; // Rotate left
    end

endmodule