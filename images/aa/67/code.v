module sequence_detector(
    input clk,
    input reset,
    input in,
    output reg out);

    reg [1:0] state;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            out <= 1'b0;
        end
        else begin
            case (state)
                2'b00: if (in) state <= 2'b01;
                2'b01: if (~in) state <= 2'b10; else state <= 2'b01;
                2'b10: if (in) begin
                    state <= 2'b00;
                    out <= 1'b1;
                end
                default: state <= 2'b00;
            endcase
        end
    end
endmodule