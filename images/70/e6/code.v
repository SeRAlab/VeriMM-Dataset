module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [7:0] data_reg;
reg [3:0] count_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_reg <= 8'b0;
        count_reg <= 4'b0;
        valid_b <= 1'b0;
        data_out <= 10'b0;
    end else begin
        if (valid_a && ready_b) begin
            data_reg <= data_reg + data_in;
            count_reg <= count_reg + 1;
            if (count_reg == 4'b1000) begin
                valid_b <= 1'b1;
                data_out <= {2'b0, data_reg};
                count_reg <= 4'b0;
            end
        end
    end
end

assign ready_a = ~valid_b;

endmodule