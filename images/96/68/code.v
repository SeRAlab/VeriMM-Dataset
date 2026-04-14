module sequence_detector (
        input clk,
        input reset,
        input in,
        output reg match);

    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 2'b00;
        else begin
            case (state)
                2'b00: state <= (in ? 2'b01 : 2'b00);
                2'b01: state <= (in ? 2'b01 : 2'b10);
                2'b10: state <= (in ? 2'b11 : 2'b00);
                2'b11: state <= (in ? 2'b01 : 2'b10);
                default: state <= 2'b00;
            endcase
        end
    end

    always @(state) begin
        if (state == 2'b11 && in == 0)
            match = 1;
        else
            match = 0;
    end
endmodule