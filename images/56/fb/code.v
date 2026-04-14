module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [7:0] data_reg1, data_reg2, data_reg3;
reg [9:0] acc_reg1, acc_reg2, acc_reg3;

reg [1:0] stage;

assign ready_a = (stage == 0) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage <= 0;
        data_reg1 <= 8'b0;
        data_reg2 <= 8'b0;
        data_reg3 <= 8'b0;
        acc_reg1 <= 10'b0;
        acc_reg2 <= 10'b0;
        acc_reg3 <= 10'b0;
        valid_b <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        case(stage)
            0: begin
                if (valid_a) begin
                    data_reg1 <= data_in;
                    stage <= 1;
                end
            end
            1: begin
                data_reg2 <= data_reg1;
                acc_reg1 <= {2'b0, data_reg1} + acc_reg1;
                stage <= 2;
            end
            2: begin
                data_reg3 <= data_reg2;
                acc_reg2 <= {2'b0, data_reg2} + acc_reg1;
                stage <= 3;
            end
            3: begin
                acc_reg3 <= {2'b0, data_reg3} + acc_reg2;
                data_out <= acc_reg3;
                valid_b <= 1'b1;
                stage <= 0;
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_b <= 1'b0;
    end
    else begin
        if (valid_b && ready_b) begin
            valid_b <= 1'b0;
        end
    end
end

endmodule