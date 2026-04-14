module dram_cell (
    input wire D,
    input wire WL,
    output reg BL
);
    reg stored_value;

    always @(posedge WL) begin
        stored_value <= D;  // Store the value when WL is high
    end

    always @(negedge WL) begin
        BL <= stored_value;  // Output the stored value when WL is low
    end
endmodule