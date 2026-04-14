module power_gating (
    input [1:0] status,
    output reg control
);
    always @(*) begin
        if (status == 2'b00) 
            control = 1'b0; // both components off
        else 
            control = 1'b1; // at least one component on
    end
endmodule