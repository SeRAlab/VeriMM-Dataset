module pipeline_processor (
    input wire clk,
    input wire rst,
    input wire [3:0] in_data,
    output reg [4:0] out_data
);
    reg [3:0] stage1_output;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_output <= 4'b0000;
            out_data <= 5'b00000;
        end else begin
            stage1_output <= in_data + 1;
            out_data <= stage1_output * 2;
        end
    end
endmodule