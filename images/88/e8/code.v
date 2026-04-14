module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [9:0] acc_data;
reg [1:0] counter;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        acc_data <= 10'b0;
        counter <= 2'b0;
        valid_b <= 1'b0;
    end
    else begin
        if(valid_a && ready_b) begin
            acc_data <= acc_data + data_in;
            counter <= counter + 1;
            if(counter == 2) begin
                data_out <= acc_data;
                acc_data <= 10'b0;
                counter <= 2'b0;
                valid_b <= 1'b1;
            end
        end
        else begin
            valid_b <= 1'b0;
        end
    end
end

assign ready_a = !valid_a || (valid_a && ready_b);

endmodule