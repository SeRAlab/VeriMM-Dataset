module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [7:0] accumulator;
reg [2:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulator <= 0;
        counter <= 0;
        valid_b <= 0;
        data_out <= 0;
    end
    else begin
        if (valid_a) begin
            accumulator <= accumulator + data_in;
            counter <= counter + 1;
            if (counter == 7) begin
                data_out <= accumulator;
                valid_b <= 1;
                counter <= 0;
                accumulator <= 0;
            end
        end
        else begin
            valid_b <= 0;
        end
    end
end

assign ready_a = ~valid_b && ready_b;

endmodule