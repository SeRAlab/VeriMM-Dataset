module sata_controller (
    input [3:0] command,
    output reg [3:0] command_out
);
    always @(*) begin
        if (command == 4'b1010) // 0xA in binary
            command_out = ~command; // Invert the command
        else
            command_out = command; // Pass the command unchanged
    end
endmodule