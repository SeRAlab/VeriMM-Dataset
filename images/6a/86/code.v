module top_module(
    input clk,
    input [2:0] a, b,
    input [1:0] select,
    output reg Y0,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg [2:0] comparison_result,
    output reg [1:0] input_selected,
    output reg [1:0] final_output
);reg [2:0] magnitude_result;
reg [2:0] a_mag;
reg [2:0] b_mag;

// Magnitude Comparator Module
always @ (posedge clk) begin
    if (a > b) begin
        magnitude_result <= 3'b001;
        a_mag <= a;
        b_mag <= 3'b000;
    end else if (a < b) begin
        magnitude_result <= 3'b010;
        a_mag <= 3'b000;
        b_mag <= b;
    end else begin
        magnitude_result <= 3'b100;
        a_mag <= 3'b000;
        b_mag <= 3'b000;
    end
end

// Selector Module
always @ (posedge clk) begin
    case (select)
        2'b00: begin
            comparison_result <= magnitude_result;
            input_selected <= 2'b00;
        end
        2'b01: begin
            comparison_result <= magnitude_result;
            input_selected <= 2'b01;
        end
        2'b10: begin
            comparison_result <= 3'b000;
            input_selected <= 2'b00;
        end
        2'b11: begin
            comparison_result <= 3'b000;
            input_selected <= 2'b01;
        end
    endcase
end

// Decoder Module
always @ (posedge clk) begin
    case (comparison_result)
        3'b001: begin
            Y0 <= 1'b0;
            Y1 <= 1'b0;
            Y2 <= 1'b0;
            Y3 <= 1'b1;
        end
        3'b010: begin
            Y0 <= 1'b0;
            Y1 <= 1'b0;
            Y2 <= 1'b1;
            Y3 <= 1'b0;
        end
        3'b100: begin
            Y0 <= 1'b0;
            Y1 <= 1'b1;
            Y2 <= 1'b0;
            Y3 <= 1'b0;
        end
        default: begin
            Y0 <= 1'b1;
            Y1 <= 1'b0;
            Y2 <= 1'b0;
            Y3 <= 1'b0;
        end
    endcase
end

// Final Output Module
always @ (posedge clk) begin
    final_output <= {Y3, Y2};
end

endmodule