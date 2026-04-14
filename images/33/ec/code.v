module dram_cell (
    input wire [3:0] data_in,
    input wire ctrl,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge ctrl or negedge ctrl) begin
        if (ctrl) begin
            storage <= data_in; // Write operation
        end else begin
            data_out <= storage; // Read operation
        end
    end
endmodule