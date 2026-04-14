module top_module(
    input [7:0] data_in,
    input [2:0] select,
    input clk,
    input rst,
    output reg [7:0] data_out,  // Changed to reg
    output reg [2:0] output_sel, // Changed to reg
    output reg [7:0] debug
);reg [7:0] shift_left;
reg [7:0] shift_right;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 0;
        output_sel <= 0;
        debug <= 0;
    end
    else begin
        case (select)
            3'b000: begin
                data_out <= data_in;
                output_sel <= 3'b000;
            end
            3'b001: begin
                data_out <= ~data_in;
                output_sel <= 3'b001;
            end
            3'b010: begin
                shift_left <= data_in << 1;
                data_out <= shift_left;
                output_sel <= 3'b010;
            end
            3'b011: begin
                shift_right <= data_in >> 1;
                data_out <= shift_right;
                output_sel <= 3'b011;
            end
            3'b100: begin
                data_out <= data_in;
                output_sel <= 3'b100;
                debug <= data_in;
            end
            default: begin
                data_out <= 0;
                output_sel <= 0;
                debug <= 0;
            end
        endcase
    end
end

endmodule