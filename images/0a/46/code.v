module data_forwarding_unit (
    input [4:0] dest_reg_prev,  // Destination register of the previous instruction
    input [4:0] src_reg_curr,    // Source register of the current instruction
    output reg forward            // Forwarding signal
);
    always @(*) begin
        if (dest_reg_prev == src_reg_curr) 
            forward = 1;          // Forwarding needed
        else 
            forward = 0;          // No forwarding
    end
endmodule