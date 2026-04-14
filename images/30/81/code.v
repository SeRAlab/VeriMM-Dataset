module dram_cell (
    input wire d,
    input wire we,
    input wire re,
    output reg q
);
    reg stored_data;

    always @(posedge we) begin
        stored_data <= d; // Write data when we is high
    end

    always @(posedge re) begin
        q <= stored_data; // Read data when re is high
    end
endmodule