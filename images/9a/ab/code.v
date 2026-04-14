module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               select      ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [8:0] accumulator;
reg [7:0] previous_data;
reg [1:0] state;

assign ready_a = ~valid_a || ready_b;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accumulator <= 0;
        previous_data <= 0;
        state <= 0;
        valid_b <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // wait for valid input
                if (valid_a) begin
                    previous_data <= data_in;
                    state <= 1;
                end
            end
            1: begin // wait for valid input
                if (valid_a) begin
                    if (select) begin
                        accumulator <= accumulator + previous_data;
                    end else begin
                        accumulator <= accumulator + data_in;
                    end
                    previous_data <= data_in;
                    state <= 1;
                end else begin
                    state <= 2;
                end
            end
            2: begin // output accumulated result
                data_out <= accumulator;
                accumulator <= 0;
                valid_b <= 1;
                state <= 0;
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        valid_b <= 0;
    end else begin
        if (valid_b && ready_b) begin
            valid_b <= 0;
        end
    end
end

endmodule