module top_module(
    input  wire        clk,
    input  wire        reset,
    input  wire [1:0]  i_data,
    input  wire        en,
    output reg  [15:0] o_data
);always @(posedge clk) begin
        if (reset == 1'b1) begin
            o_data <= {16{1'b0}};
        end else begin
            if (en == 1'b1) begin
                o_data <= {o_data[13:0], i_data};
            end
        end
    end


endmodule