module dram_cell (
    input wire clk,
    input wire we, // write enable
    input wire [0:0] data_in, // input data
    output reg [0:0] data_out // output data
);
    reg [0:0] storage; // internal storage for the bit

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // write data to storage
        end
    end

    always @(posedge clk) begin
        data_out <= storage; // read data from storage
    end
endmodule