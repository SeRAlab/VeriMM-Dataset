module sata_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [1:0] command, // 00: READ, 01: WRITE, 10: FLUSH
    output reg status // 0: ERROR, 1: SUCCESS
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            status <= 0; // Default to ERROR on reset
        end else if (start) begin
            case (command)
                2'b00: begin // READ command
                    status <= 1; // SUCCESS
                end
                2'b01: begin // WRITE command
                    status <= 1; // SUCCESS
                end
                2'b10: begin // FLUSH command
                    status <= 1; // SUCCESS
                end
                default: begin
                    status <= 0; // ERROR for invalid command
                end
            endcase
        end
    end
endmodule