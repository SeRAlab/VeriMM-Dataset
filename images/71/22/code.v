module seq_detector(
    input clk,
    input data,
    output reg detected
);

    reg [2:0] state;

    always @(posedge clk) begin
        case (state)
            3'b000: state <= data ? 3'b001 : 3'b000;
            3'b001: state <= data ? 3'b001 : 3'b010;
            3'b010: state <= data ? 3'b011 : 3'b000;
            3'b011: state <= data ? 3'b001 : 3'b100;
            3'b100: state <= data ? 3'b011 : 3'b000;
            default: state <= 3'b000;
        endcase
        detected <= (state == 3'b100) && data;
    end

endmodule