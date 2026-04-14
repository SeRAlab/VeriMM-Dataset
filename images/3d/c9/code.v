module sd_card_interface (
    input [7:0] cmd,
    input valid,
    output reg [7:0] resp
);
    always @(*) begin
        if (valid) begin
            case (cmd)
                8'h01: resp = 8'hFF; // Command 1
                8'h02: resp = 8'hAA; // Command 2
                8'h03: resp = 8'h55; // Command 3
                default: resp = 8'h00; // Default response
            endcase
        end else begin
            resp = 8'h00; // No valid command
        end
    end
endmodule