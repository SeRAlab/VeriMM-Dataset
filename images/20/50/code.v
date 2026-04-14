module sd_card_controller (
    input [3:0] command,
    output reg [3:0] response
);
    always @* begin
        case (command)
            4'b0001: response = 4'b0010;
            4'b0010: response = 4'b0011;
            4'b0011: response = 4'b0100;
            default: response = 4'b0000;
        endcase
    end
endmodule