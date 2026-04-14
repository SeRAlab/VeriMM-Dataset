module top_module(
    input up_down,
    input load,
    input clock,
    input reset,
    output reg [3:0] count
);reg [3:0] count_reg1;
reg [3:0] count_reg2;

always @(posedge clock) begin
    if (reset) begin
        count_reg1 <= 4'b0;
        count_reg2 <= 4'b0;
    end
    else if (load) begin
        count_reg1 <= count;
        count_reg2 <= count;
    end
    else begin
        if (up_down) begin
            count_reg1 <= count_reg2 + 4'b1;
        end
        else begin
            count_reg1 <= count_reg2 - 4'b1;
        end
        count_reg2 <= count_reg1;
    end
end

assign count = count_reg2;

endmodule