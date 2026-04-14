module top_module(
    input [1:0] op,
    input [7:0] a,
    input [7:0] b,
    input reset,
    output reg [7:0] result,
    output reg overflow
);reg [7:0] temp_result;

always @(*) begin
    case(op)
        2'b00: temp_result = a + b;
        2'b01: temp_result = a - b;
        2'b10: temp_result = a * b;
        2'b11: begin
            if (b == 8'h00) begin
                temp_result = 8'h00;
                overflow = 1;
            end
            else begin
                temp_result = a / b;
                overflow = (temp_result > 8'hff) ? 1 : 0;
            end
        end
    endcase
end

always @(posedge reset) begin
    if (reset) begin
        result <= 8'h00;
        overflow <= 0;
    end
    else begin
        result <= temp_result;
    end
end

endmodule