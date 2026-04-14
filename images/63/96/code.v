module top_module( output reg Q, input D, Clock, reset_b);always @ ( posedge Clock, negedge reset_b)
        if (reset_b == 0) Q <= 0; else Q <= D;endmodule