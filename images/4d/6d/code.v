module top_module(
    input [2:0] sel,
    input [5:0] data,
    output reg [3:0] out
);// Priority Encoder
    wire [2:0] encoded_sel;
    assign encoded_sel = ~sel ? 3'b111 : {~sel[2], ~sel[1], ~sel[0]};

    // Decoder
    reg [5:0] decoded_data;
    always @* begin
        case(encoded_sel)
            3'b001: decoded_data = data[3:0];
            3'b010: decoded_data = data[7:4];
            3'b100: decoded_data = data[11:8];
            3'b000: decoded_data = data[15:12];
            3'b011: decoded_data = data[19:16];
            3'b101: decoded_data = data[23:20];
            default: decoded_data = 4'b0000;
        endcase
    end

    // Output
    always @* begin
        if (sel < 6) begin
            out = decoded_data;
        end else begin
            out = 4'b0000;
        end
    end

endmodule