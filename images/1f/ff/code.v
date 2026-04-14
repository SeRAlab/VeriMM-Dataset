module sata_controller(
    input wire clk,
    input wire rst,
    input wire read_cmd,
    input wire write_cmd,
    output reg operation_success
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            operation_success <= 0;
        end else begin
            if (read_cmd || write_cmd) begin
                operation_success <= 1; // operation successful
            end else begin
                operation_success <= 0; // no valid operation
            end
        end
    end
endmodule