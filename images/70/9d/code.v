module binary_counter (
        input clk,
        input reset,
        output reg [1:0] state,
        output reg out);

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 2'b00;
        else
            state <= state + 1;
    end

    always @(*) begin
        case (state)
            2'b00: out = 0;
            2'b01: out = 1;
            2'b10: out = 0;
            2'b11: out = 1;
            default: out = 0;
        endcase
    end
endmodule