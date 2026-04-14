module nvme_command_decoder(
    input [4:0] command_input,
    output reg [15:0] command_output
);

always @(*) begin
    case (command_input)
        5'b00000: command_output = 16'h0001; // Read
        5'b00001: command_output = 16'h0002; // Write
        5'b00010: command_output = 16'h0004; // Flush
        5'b00011: command_output = 16'h0008; // Identify
        5'b00100: command_output = 16'h0010; // Delete
        default: command_output = 16'hFFFF;    // Invalid Command
    endcase
end

endmodule