module top_module(
    input clk,
    input reset,
    input [3:0] DataIn,
    input [1:0] Ctrl,
    output [3:0] DataOut
);reg [3:0] temp;

    always @(posedge clk, negedge reset) begin
        if (~reset) begin
            temp <= 4'b0;
        end else begin
            case (Ctrl)
                2'b00: temp <= DataIn;
                2'b01: temp <= ~DataIn;
                2'b10: temp <= {DataIn[1:0], DataIn[3:2]};
                2'b11: temp <= {DataIn[2:0], DataIn[3]};
            endcase
        end
    end

    assign DataOut = temp;

endmodule