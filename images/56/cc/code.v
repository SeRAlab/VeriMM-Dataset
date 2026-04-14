module top_module(
    // Inputs
    clk,
    reset,
    stream_data,
    stream_startofpacket,
    stream_endofpacket,
    stream_empty,
    stream_valid,
    master_waitrequest,
    // Outputs
    stream_ready,
    master_write,
    master_writedata,
    inc_address,
    reset_address
);// Parameter Declarations
    parameter DW = 15; // Frame's data width
    parameter EW = 0; // Frame's empty width
    parameter MDW = 15; // Avalon master's data width

    // Port Declarations
    // Inputs
    input clk;
    input reset;
    input [DW:0] stream_data;
    input stream_startofpacket;
    input stream_endofpacket;
    input [EW:0] stream_empty;
    input stream_valid;
    input master_waitrequest;
    // Outputs
    output stream_ready;
    output master_write;
    output [MDW:0] master_writedata;
    output inc_address;
    output reset_address;

    // Internal Wires and Registers Declarations
    reg [DW:0] temp_data;
    reg temp_valid;

    // Output Registers
    reg stream_ready_reg;

    // Sequential Logic
    always @(posedge clk) begin
        if (reset & ~master_waitrequest) begin
            temp_data <= 'h0;
            temp_valid <= 1'b0;
            stream_ready_reg <= 1'b0;
        end else if (stream_ready_reg) begin
            temp_data <= stream_data;
            temp_valid <= stream_valid;
            stream_ready_reg <= 1'b0;
        end
    end

    // Combinational Logic
    assign stream_ready = ~reset & (~temp_valid | ~master_waitrequest) & ~stream_ready_reg;
    assign master_write = temp_valid;
    assign master_writedata = temp_data;
    assign inc_address = stream_ready & stream_valid;
    assign reset_address = inc_address & stream_startofpacket;

    always @(posedge clk) begin
        if (reset) begin
            stream_ready_reg <= 1'b0;
        end else if (stream_ready) begin
            stream_ready_reg <= 1'b1;
        end
    end

endmodule