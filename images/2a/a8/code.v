module power_gating_controller(
    input [2:0] ctrl,
    input [1:0] enable,
    output reg power_on
);
    always @(*) begin
        if (ctrl == 3'b111 && enable == 2'b11) 
            power_on = 1'b1;
        else 
            power_on = 1'b0;
    end
endmodule