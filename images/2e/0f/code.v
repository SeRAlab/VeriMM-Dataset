module sata_command_decoder (
    input wire clk,
    input wire rst,
    input wire [3:0] command,
    output reg valid_command
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid_command <= 0;
        end else begin
            if (command >= 4'b0001 && command <= 4'b1000) begin
                valid_command <= 1;
            end else begin
                valid_command <= 0;
            end
        end
    end
endmodule