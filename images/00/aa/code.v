module eeprom_cell (
    input wire clk,
    input wire WE,
    input wire RE,
    input wire D,
    output reg Q
);

    reg stored_data;

    always @(posedge clk) begin
        if (WE) begin
            stored_data <= D;
        end
        if (RE) begin
            Q <= stored_data;
        end
    end

endmodule