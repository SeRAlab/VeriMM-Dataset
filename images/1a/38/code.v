module mpc_control (
    input [4:0] current_state,
    output reg [4:0] control_signal
);
    always @(*) begin
        if (current_state > 5'd16) 
            control_signal = 5'd31; // Increase
        else 
            control_signal = 5'd0;  // Decrease
    end
endmodule