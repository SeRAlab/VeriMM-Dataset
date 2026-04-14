module png_filter_selector (
    input [2:0] filter_type,
    output reg [2:0] filter_code,
    output reg valid
);
    always @(*) begin
        case (filter_type)
            3'b000: begin // None
                filter_code = 3'b000;
                valid = 1;
            end
            3'b001: begin // Sub
                filter_code = 3'b001;
                valid = 1;
            end
            3'b010: begin // Up
                filter_code = 3'b010;
                valid = 1;
            end
            3'b011: begin // Average
                filter_code = 3'b011;
                valid = 1;
            end
            3'b100: begin // Paeth
                filter_code = 3'b100;
                valid = 1;
            end
            default: begin // Invalid filter type
                filter_code = 3'bxxx;
                valid = 0;
            end
        endcase
    end
endmodule