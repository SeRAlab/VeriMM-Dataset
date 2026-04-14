module top_module(
    input [7:0] a, b, c, d,
    output reg [7:0] final_output);reg [1:0] index;
    reg [7:0] max_value;
    reg [7:0] constant = 2;

    always @* begin
        if (a >= b && a >= c && a >= d) begin
            max_value = a;
            index = 2'b00;
        end else if (b >= c && b >= d) begin
            max_value = b;
            index = 2'b01;
        end else if (c >= d) begin
            max_value = c;
            index = 2'b10;
        end else begin
            max_value = d;
            index = 2'b11;
        end
    end

    always @* begin
        case (index)
            2'b00: final_output = (max_value * constant) >> 1;
            2'b01: final_output = (max_value * constant) >> 1;
            2'b10: final_output = (max_value * constant) >> 2;
            2'b11: final_output = (max_value * constant) >> 2;
            default: final_output = 8'b0; // Added default case
        endcase
    end

endmodule