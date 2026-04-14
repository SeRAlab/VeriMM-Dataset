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
reg [1:0] counter;
reg valid_reg [3:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 2'b0;
        valid_b <= 1'b0;
        data_out <= 10'b0;
    end else begin
        if (valid_a && ready_b) begin
            data_reg[counter] <= data_in;
            valid_reg[counter] <= 1'b1;
            counter <= counter + 1'b1;
        end

        if (counter == 2'b11) begin
            data_out <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
            valid_b <= valid_reg[3];
            counter <= 2'b0;
        end else begin
            valid_b <= 1'b0;
        end
    end
end

assign ready_a = (counter != 2'b11);

endmodule