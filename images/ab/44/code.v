module top_module(
    input wire [15:0] in,
    input wire [2:0] select,
    output wire [7:0] final_output,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);// Binary splitter
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

    // Barrel shifter
    reg [7:0] shifted_out;
    always @(*) begin
        case (select)
            3'b000: shifted_out = out_hi;
            3'b001: shifted_out = out_hi >> 1;
            3'b010: shifted_out = out_hi >> 2;
            3'b011: shifted_out = out_hi >> 3;
            3'b100: shifted_out = out_hi >> 4;
            3'b101: shifted_out = out_hi >> 5;
            3'b110: shifted_out = out_hi >> 6;
            3'b111: shifted_out = out_hi >> 7;
        endcase
    end

    // Multiplexer
    assign outv = select;
    assign o2 = select[2];
    assign o1 = select[1];
    assign o0 = select[0];

    // Final output
    assign final_output = {shifted_out, select};

endmodule