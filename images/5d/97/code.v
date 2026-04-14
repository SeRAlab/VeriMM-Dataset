module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [7:0] data_reg [3:0];
reg [9:0] sum_reg [2:0];
reg [1:0] count_reg;
reg [1:0] index_reg;

assign ready_a = ~valid_b;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        valid_b <= 0;
        data_out <= 0;
        count_reg <= 0;
        index_reg <= 0;
        sum_reg[0] <= 0;
        sum_reg[1] <= 0;
        sum_reg[2] <= 0;
        data_reg[0] <= 0;
        data_reg[1] <= 0;
        data_reg[2] <= 0;
        data_reg[3] <= 0;
    end else begin
        if (valid_a && ready_b) begin
            valid_b <= 1;
            data_reg[count_reg] <= data_in;
            count_reg <= count_reg + 1;
            if (count_reg == 3) begin
                count_reg <= 0;
                sum_reg[index_reg] <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                index_reg <= index_reg + 1;
                if (index_reg == 2) begin
                    index_reg <= 0;
                    data_out <= sum_reg[0];
                    sum_reg[0] <= sum_reg[1];
                    sum_reg[1] <= sum_reg[2];
                    sum_reg[2] <= 0;
                end
            end
        end
    end
end

endmodule