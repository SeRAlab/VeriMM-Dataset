module dram_cell (
    input wire D,
    input wire WL,
    output reg BL
);
    reg stored_data;

    always @(posedge WL) begin
        stored_data <= D; // Store data on the rising edge of WL
    end

    always @(negedge WL) begin
        BL <= stored_data; // Output stored data on the falling edge of WL
    end
endmodule