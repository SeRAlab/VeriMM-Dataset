module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output reg         valid_b     ,
    output reg [9:0]   data_out
);reg [9:0] acc;  // Accumulator register
reg [2:0] stage;  // Pipeline stage register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        acc <= 10'd0;
        stage <= 3'd0;
        valid_b <= 1'b0;
        data_out <= 10'd0;
    end else begin
        case (stage)
            3'd0: begin  // Stage 0: Idle
                if (valid_a) begin
                    acc <= data_in;
                    stage <= 3'd1;
                end
            end
            3'd1: begin  // Stage 1: Accumulate
                if (valid_a) begin
                    acc <= acc + data_in;
                    stage <= 3'd2;
                end
            end
            3'd2: begin  // Stage 2: Accumulate
                if (valid_a) begin
                    acc <= acc + data_in;
                    stage <= 3'd3;
                end
            end
            3'd3: begin  // Stage 3: Output
                data_out <= acc;
                valid_b <= 1'b1;
                stage <= 3'd0;
            end
        endcase
    end
end

assign ready_a = (stage == 3'd0);

endmodule