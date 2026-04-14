module top_module(input [2:0] D,
     input CLK,
     input [1:0] AR,
     input LD,
     output reg [2:0] Q);always @(posedge CLK) begin
        if (AR[0] && AR[1]) // if both bits of AR are high, clear the register
            Q <= 3'b0;
        else if (LD) // if LD is high, load the value of D into the register
            Q <= D;
    end

endmodule