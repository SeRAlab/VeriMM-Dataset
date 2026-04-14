module top_module(clk, rst, data, stb, data_out, ack, valid);parameter DATA_BITS = 8; // Set the data width

    input clk, rst, stb;
    input [DATA_BITS-1:0] data;
    output [DATA_BITS-1:0] data_out;
    output ack, valid;

    reg [DATA_BITS-1:0] data_reg; // Register to hold input data
    reg sync_stb; // Synchronization signal
    reg ack_reg; // Register to hold acknowledgement signal
    reg valid_reg; // Register to hold validation signal

    always @(posedge clk) begin
        if (rst) begin
            sync_stb <= 0;
            data_reg <= 0;
            ack_reg <= 0;
            valid_reg <= 0;
        end else begin
            sync_stb <= stb;
            data_reg <= data;
            ack_reg <= 1;
            valid_reg <= sync_stb;
        end
    end

    assign data_out = data_reg;
    assign ack = ack_reg;
    assign valid = valid_reg;

endmodule