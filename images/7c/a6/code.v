module top_module(
    input A, B,
    input [15:0] data_in_port1,
    input write_en_port1,
    output X,
    output [15:0] Y
);// Define the 16-bit dual-port RAM module
    reg [15:0] ram [0:65535];
    always @(posedge write_en_port1) begin
        ram[{A,B}] <= data_in_port1;
    end
    
    // Define the 4-to-16 decoder module
    reg [15:0] decoder_out;
    always @(*) begin
        case (ram[{A,B}])
            16'h0000: decoder_out = 16'hFFFF;
            16'h0001: decoder_out = 16'hFFF0;
            16'h0002: decoder_out = 16'hFF0F;
            16'h0003: decoder_out = 16'hFF00;
            16'h0004: decoder_out = 16'hF0FF;
            16'h0005: decoder_out = 16'hF0F0;
            16'h0006: decoder_out = 16'hF00F;
            16'h0007: decoder_out = 16'hF000;
            16'h0008: decoder_out = 16'h0FFF;
            16'h0009: decoder_out = 16'h0FF0;
            16'h000A: decoder_out = 16'h0F0F;
            16'h000B: decoder_out = 16'h0F00;
            16'h000C: decoder_out = 16'h00FF;
            16'h000D: decoder_out = 16'h00F0;
            16'h000E: decoder_out = 16'h000F;
            16'h000F: decoder_out = 16'h0000;
            default: decoder_out = 16'h0000;
        endcase
    end
    
    // Assign the outputs
    assign X = ram[{A,B}];
    assign Y = ~decoder_out;

endmodule