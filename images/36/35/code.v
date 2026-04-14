module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    
    always @(posedge clk) begin
        if (S && R) 
            Q <= Q; // invalid state, hold previous state
        else if (S) 
            Q <= 1'b1; // set state
        else if (R) 
            Q <= 1'b0; // reset state
        // else Q remains the same
    end

endmodule