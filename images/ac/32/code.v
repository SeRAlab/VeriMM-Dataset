module top_module(
    input A, B, C, EN,
    output reg Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7
);always @ (A or B or C or EN) begin
    if (EN) begin
        case ({A, B, C})
            3'b000: begin Y0 = 1; Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; Y5 = 0; Y6 = 0; Y7 = 0; end
            3'b001: begin Y0 = 0; Y1 = 1; Y2 = 0; Y3 = 0; Y4 = 0; Y5 = 0; Y6 = 0; Y7 = 0; end
            3'b010: begin Y0 = 0; Y1 = 0; Y2 = 1; Y3 = 0; Y4 = 0; Y5 = 0; Y6 = 0; Y7 = 0; end
            3'b011: begin Y0 = 0; Y1 = 0; Y2 = 0; Y3 = 1; Y4 = 0; Y5 = 0; Y6 = 0; Y7 = 0; end
            3'b100: begin Y0 = 0; Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 1; Y5 = 0; Y6 = 0; Y7 = 0; end
            3'b101: begin Y0 = 0; Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; Y5 = 1; Y6 = 0; Y7 = 0; end
            3'b110: begin Y0 = 0; Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; Y5 = 0; Y6 = 1; Y7 = 0; end
            3'b111: begin Y0 = 0; Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; Y5 = 0; Y6 = 0; Y7 = 1; end
        endcase
    end else begin
        Y0 = 0; Y1 = 0; Y2 = 0; Y3 = 0; Y4 = 0; Y5 = 0; Y6 = 0; Y7 = 0;
    end
end

endmodule