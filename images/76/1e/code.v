module top_module(
    count,
    enable,
    clock,
    reset
);output [7:0] count;
reg [7:0] count;
input enable;
input clock;
input reset;






always @(posedge clock, negedge reset) begin: INC_INCLOGIC
    if (reset == 0) begin
        count <= 0;
    end
    else begin
        if (enable) begin
            count <= (count + 1);
        end
    end
end

endmodule