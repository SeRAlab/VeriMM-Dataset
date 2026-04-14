module dram_cell (
    input wire [3:0] data_in,
    input wire control,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge control) begin
        storage <= data_in; // Write data when control is high
    end

    always @(negedge control) begin
        data_out <= storage; // Output data when control is low
    end
endmodule