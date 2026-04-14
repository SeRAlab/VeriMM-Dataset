module sram_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    reg stored_value;

    always @(posedge WE) begin
        stored_value <= D; // Write operation
    end

    always @(posedge RE) begin
        Q <= stored_value; // Read operation
    end
endmodule