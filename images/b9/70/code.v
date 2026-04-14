module top_module( 
    input wire clk,
    input wire reset,
    input wire [15:0] in,
    input wire select,
    output wire [3:0] out_hi,
    output wire [3:0] out_lo,
    output wire [1023:0] out_demux );// Demultiplexer
    reg [255:0] demux_out;
    always @ (in[7:4])
        case (in[7:4])
            8'h00: demux_out <= 256'b00000001;
            8'h01: demux_out <= 256'b00000010;
            // ... continue for all 256 cases
            default: demux_out <= 256'b0;
        endcase
    
    // Multiplexer
    wire [3:0] mux_out_hi;
    wire [3:0] mux_out_lo;
    assign mux_out_hi = in[15:12];
    assign mux_out_lo = in[11:8];
    wire [3:0] mux_out;
    assign mux_out = select ? mux_out_hi : mux_out_lo;
    
    // Control logic
    wire use_demux;
    assign use_demux = select < 8'h80;
    
    // Output
    assign out_hi = use_demux ? demux_out[(in[7:4]*16)+:4] : mux_out_hi;
    assign out_lo = use_demux ? demux_out[(in[7:4]*16)+4+:4] : mux_out_lo;
    assign out_demux = use_demux ? demux_out : 1024'b0;

endmodule