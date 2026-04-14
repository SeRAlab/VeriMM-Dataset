module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [7:0] data_reg_1, data_reg_2, data_reg_3, data_reg_4;
reg [9:0] acc_reg_1, acc_reg_2, acc_reg_3, acc_reg_4;

wire [9:0] acc_out_1, acc_out_2, acc_out_3;

assign acc_out_1 = acc_reg_1 + data_reg_1;
assign acc_out_2 = acc_reg_2 + data_reg_2;
assign acc_out_3 = acc_reg_3 + data_reg_3;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_reg_1 <= 8'b0;
        data_reg_2 <= 8'b0;
        data_reg_3 <= 8'b0;
        data_reg_4 <= 8'b0;
        acc_reg_1 <= 10'b0;
        acc_reg_2 <= 10'b0;
        acc_reg_3 <= 10'b0;
        acc_reg_4 <= 10'b0;
        valid_b <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        if (valid_a && ready_b) begin
            data_reg_1 <= data_in;
            data_reg_2 <= data_reg_1;
            data_reg_3 <= data_reg_2;
            data_reg_4 <= data_reg_3;
            acc_reg_1 <= acc_out_1;
            acc_reg_2 <= acc_out_2;
            acc_reg_3 <= acc_out_3;
            acc_reg_4 <= acc_reg_3;
            valid_b <= 1'b0;
            data_out <= acc_reg_4;
        end
        else begin
            data_reg_1 <= data_reg_1;
            data_reg_2 <= data_reg_2;
            data_reg_3 <= data_reg_3;
            data_reg_4 <= data_reg_4;
            acc_reg_1 <= acc_reg_1;
            acc_reg_2 <= acc_reg_2;
            acc_reg_3 <= acc_reg_3;
            acc_reg_4 <= acc_reg_4;
            valid_b <= valid_a && ~valid_b;
            data_out <= data_out;
        end
    end
end

assign ready_a = ~valid_b;

endmodule