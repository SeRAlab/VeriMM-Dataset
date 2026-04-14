module data_forwarding(
    input [4:0] reg_dest_ex,   // Destination register from EX stage
    input [4:0] reg_dest_id,    // Destination register from ID stage
    input reg_valid_ex,          // Validity of EX destination register
    input reg_valid_id,          // Validity of ID destination register
    output reg forward_a,        // Forwarding signal for A input
    output reg forward_b         // Forwarding signal for B input
);
    always @(*) begin
        forward_a = 0;
        forward_b = 0;

        if (reg_valid_ex && (reg_dest_ex == reg_dest_id)) begin
            forward_a = 1; // Forward from EX to ID
        end
        if (reg_valid_ex && (reg_dest_ex == reg_dest_id)) begin
            forward_b = 1; // Forward from EX to ID
        end
    end
endmodule