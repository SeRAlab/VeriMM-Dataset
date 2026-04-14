module dram_cell (
    input wire D,
    input wire RE,
    input wire WE,
    input wire CLK,
    output reg Q
);
    reg stored_value;

    always @(posedge CLK) begin
        if (WE) begin
            stored_value <= D; // Write operation
        end
    end

    always @(posedge CLK) begin
        if (RE) begin
            Q <= stored_value; // Read operation
        end
    end
endmodule