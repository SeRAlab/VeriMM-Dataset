module top_module(
    input clk,
    input rst,
    input rotary_A,
    input rotary_B,
    output reg rotary_event,
    output reg rotary_left
);reg rotary_A_previous = 0;
    wire w1;

    assign w1 = ~rotary_A_previous & rotary_A;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            
            rotary_A_previous <= 0;
            rotary_event <= 0;
            rotary_left <= 0;
        end else begin
            rotary_A_previous <= rotary_A;
            if(w1) begin
                rotary_event <= 1;
                rotary_left <= rotary_B;
            end else begin
                rotary_event <= 0;
                rotary_left <= rotary_left;
            end
        end
    end

endmodule