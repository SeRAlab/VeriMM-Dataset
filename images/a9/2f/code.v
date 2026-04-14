module top_module(
    input clk,
    input reset,
    input set,
    input d,
    output reg q,
    output reg qn
);reg [1:0] hold_counter;

always @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
        qn <= 1'b1;
        hold_counter <= 2'b00;
    end else if (set) begin
        q <= 1'b1;
        qn <= 1'b0;
        hold_counter <= 2'b00;
    end else begin
        if (hold_counter == 2'b11) begin
            q <= d;
            qn <= ~d;
            hold_counter <= 2'b00;
        end else begin
            hold_counter <= hold_counter + 1'b1;
        end
    end
end

endmodule