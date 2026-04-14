module power_gating (
    input [1:0] ctrl,
    input enable,
    output reg power_gate
);
    always @(*) begin
        if (enable && (ctrl == 2'b11)) 
            power_gate = 1'b1;
        else 
            power_gate = 1'b0;
    end
endmodule