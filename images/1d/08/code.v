module down_counter (
    input clk,
    input reset,
    input enable,
    input [4:0] init_value,
    output reg [4:0] count
);
    
    initial begin
        count = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= init_value;
        end else if (enable && count > 0) begin
            count <= count - 1;
        end
    end
endmodule