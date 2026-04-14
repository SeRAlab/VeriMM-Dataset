module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [2:0] count;
reg [9:0] acc_data;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        count <= 0;
        acc_data <= 0;
        valid_b <= 0;
    end
    else begin
        if(valid_a) begin
            acc_data <= acc_data + data_in;
            count <= count + 1;
            if(count == 7) begin
                data_out <= acc_data;
                valid_b <= 1;
                count <= 0;
                acc_data <= 0;
            end
        end
    end
end

assign ready_a = !valid_b && ready_b;

endmodule