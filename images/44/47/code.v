module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [7:0] accu_reg;
reg [3:0] count_reg;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        accu_reg <= 8'h00;
        count_reg <= 4'h0;
        valid_b <= 1'b0;
        data_out <= 10'h000;
    end else begin
        if(valid_a) begin
            accu_reg <= accu_reg + data_in;
            count_reg <= count_reg + 1;
            if(count_reg == 4'hF) begin
                data_out <= {accu_reg, 2'h0};
                valid_b <= 1'b1;
            end
        end
    end
end

assign ready_a = ~valid_b & ready_b;

endmodule