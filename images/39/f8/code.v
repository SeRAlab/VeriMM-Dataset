module eeprom (
    input wire CLK,
    input wire WE,
    input wire RE,
    input wire [7:0] D,
    output reg [7:0] Q
);
    reg [7:0] memory;

    always @(posedge CLK) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
    end

    always @(*) begin
        if (RE) begin
            Q <= memory; // Read data from memory
        end else begin
            Q <= Q; // Hold previous data
        end
    end
endmodule