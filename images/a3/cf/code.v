module top_module(
    input CLK, SHIFT_LEFT, SHIFT_RIGHT,
    input [3:0] DATA,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (SHIFT_LEFT) begin
            Q <= {Q[2:0], DATA[3]};
        end
        else if (SHIFT_RIGHT) begin
            Q <= {DATA[0], Q[3:1]};
        end
    end

endmodule