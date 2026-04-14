module top_module(
    input [3:0] num,
    input clk,                  // Added clk input
    output reg [3:0] sqrt
);reg [3:0] num_reg;
reg [1:0] stage;
reg [3:0] sqrt_reg;
reg [3:0] sqrt_next;
reg [3:0] num_next;
reg [3:0] num_temp;

always @(posedge clk) begin
    num_reg <= num;           // Moved to clocked process
end

always @(posedge clk) begin
    case(stage)
        0: begin
            sqrt_reg <= 4'b0;  // Changed to 4'b0
            num_next <= num_reg;
            num_temp <= num_reg;
        end
        1: begin
            sqrt_reg <= {sqrt_reg[2:0], 1'b0};
            num_next <= {num_temp[2:0], 1'b0};
            num_temp <= num_temp - {sqrt_reg[2:0], 1'b0};
        end
        2: begin
            sqrt_reg <= {sqrt_reg[1:0], 1'b1};
            num_next <= {num_temp[1:0], 2'b00};
            num_temp <= num_temp - {sqrt_reg[1:0], 2'b00};
        end
        3: begin
            sqrt_reg <= {sqrt_reg[0], 1'b0};
            num_next <= {num_temp[0], 3'b000};
            num_temp <= num_temp - {sqrt_reg[0], 3'b000};
        end
        default: begin
            sqrt_reg <= sqrt_reg;
            num_next <= num_next;
            num_temp <= num_temp;
        end
    endcase
    stage <= stage + 1;
end

always @(posedge clk) begin
    case(stage)
        0: begin
            sqrt_next <= 4'b0;    // Changed to 4'b0
        end
        1: begin
            sqrt_next <= {sqrt_reg[2:0], 1'b1};
        end
        2: begin
            sqrt_next <= {sqrt_reg[1:0], 1'b0};
        end
        3: begin
            sqrt_next <= {sqrt_reg[0], 1'b1};
        end
        default: begin
            sqrt_next <= sqrt_next;
        end
    endcase
end

always @(posedge clk) begin
    sqrt <= sqrt_next;
    // Stage reset is now handled effectively
    if(stage == 3) begin
        stage <= 0;
    end
end

endmodule