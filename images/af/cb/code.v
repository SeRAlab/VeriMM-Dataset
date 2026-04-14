module top_module(
    input clk,
    input reset,
    input load,
    input up_down,
    input [3:0] data_in,
    input select_counter,
    input select_output,
    output reg [3:0] count_out,
    output reg [3:0] sum_out
);reg [3:0] counter1;
reg [3:0] counter2;
reg [3:0] sum;

always @(posedge clk) begin
    if (reset) begin
        counter1 <= 4'b0;
        counter2 <= 4'b0;
        sum <= 4'b0;
    end else if (load) begin
        counter1 <= data_in;
        counter2 <= data_in;
    end else if (select_counter) begin
        if (up_down) begin
            if (counter2 == 4'b1111) begin
                counter2 <= 4'b0000;
            end else begin
                counter2 <= counter2 + 1;
            end
        end else begin
            if (counter2 == 4'b0000) begin
                counter2 <= 4'b1111;
            end else begin
                counter2 <= counter2 - 1;
            end
        end
    end else begin
        if (up_down) begin
            if (counter1 == 4'b1111) begin
                counter1 <= 4'b0000;
            end else begin
                counter1 <= counter1 + 1;
            end
        end else begin
            if (counter1 == 4'b0000) begin
                counter1 <= 4'b1111;
            end else begin
                counter1 <= counter1 - 1;
            end
        end
    end
    
    sum <= counter1 + counter2;
    
    if (select_output) begin
        count_out <= select_counter ? counter2 : counter1;
        sum_out <= sum;
    end else begin
        count_out <= sum;
        sum_out <= 4'b0;
    end
end

endmodule