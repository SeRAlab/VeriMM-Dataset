module top_module(
    input clk,
    input rst,
    input [15:0] a,
    input [15:0] b,
    input [4:0] shift,
    input [3:0] select,
    output reg [7:0] out
);reg [15:0] and_out;
    reg [31:0] shift_out;
    reg [15:0] add_out;
    reg [3:0] counter;

    // AND gate module
    always @ (a, b) begin
        case ({a, b})
            16'b11: and_out <= 1;
            default: and_out <= 0;
        endcase
    end

    // Byte-shifting module
    always @ (a, b, shift) begin
        shift_out[31:24] = b[15:8];
        shift_out[23:16] = b[7:0];
        shift_out[15:8] = a[15:8];
        shift_out[7:0] = a[7:0];
        shift_out = shift_out << shift;
    end

    // Functional module (bitwise addition with constant value)
    always @ (shift_out) begin
        add_out = shift_out + 16'h1234;
    end

    // Output selection
    always @ (select, and_out, add_out) begin
        case (select)
            4'b0000: out <= and_out[7:0];
            4'b0001: out <= add_out[15:8];
            default: out <= 0;
        endcase
    end

    // Counter
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            counter <= 0;
        end else if (counter == shift) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule