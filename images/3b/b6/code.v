module dram_cell (
    input [3:0] data_in,
    input ctrl,
    output reg [3:0] data_out
);
    always @(posedge ctrl) begin
        if (ctrl) begin
            data_out <= data_in; // Write operation
        end
    end

    always @(negedge ctrl) begin
        // Read operation
        data_out <= data_out; // Maintain current data
    end
endmodule