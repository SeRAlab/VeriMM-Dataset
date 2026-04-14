module top_module(
    input clk,
    input [$clog2(MEMORY_DEPTH)-1:0] write_address,
    input [MEMORY_WIDTH-1:0] data_in,
    input write_enable,
    input [$clog2(MEMORY_DEPTH)-1:0] read_address,
    input read_enable,
    output [MEMORY_WIDTH-1:0] data_out
);parameter MEMORY_WIDTH          = 512                               ;                       
    parameter MEMORY_DEPTH          = 512                               ;                      
    parameter MEMORY_LATENCY        = "LOW_LATENCY"                     ; 
    parameter INIT_FILE             = ""                                ;

    reg [MEMORY_WIDTH-1:0] mem [MEMORY_DEPTH-1:0];

    always @(posedge clk) begin
        if (write_enable) begin
            mem[write_address] <= data_in;
        end
    end

    assign data_out = mem[read_address];

endmodule