module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [7:0] acc_reg;
    reg [2:0] count_reg;
    reg [9:0] pipe_reg;
    wire [2:0] next_count;
    wire [9:0] next_pipe;
    
    assign next_count = (count_reg == 3'b111) ? 3'b000 : count_reg + 1'b1; // Corrected line
    assign next_pipe = (count_reg == 3'b111) ? {2'b0, acc_reg} : pipe_reg;  // Corrected line
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            acc_reg <= 8'b0;
            count_reg <= 3'b0;
            pipe_reg <= 10'b0;
            valid_b <= 1'b0;
            data_out <= 10'b0;
        end
        else begin
            acc_reg <= (valid_a) ? acc_reg + data_in : acc_reg;
            count_reg <= (valid_a) ? next_count : count_reg;
            pipe_reg <= next_pipe;
            valid_b <= (count_reg == 3'b111) ? 1'b1 : 1'b0;
            data_out <= (count_reg == 3'b111) ? pipe_reg : 10'b0;
        end
    end
    
    assign ready_a = ~valid_b & ready_b;
    
endmodule