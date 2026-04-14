module top_module(
    input clk,             // Clock input
    input rst_n,           // Active low reset input
    input [7:0] in,        // 8-bit input for the accumulator
    input valid_a,         // Valid input for the accumulator
    input ready_b,         // Ready input for the priority encoder
    output reg ready_a,    // Ready output for the accumulator
    output reg valid_b,    // Valid output for the priority encoder
    output reg [9:0] out   // 10-bit output from the functional module
);// Priority Encoder
    reg [7:0] input_reg;
    reg [2:0] priority_enc;
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            input_reg <= 8'b0;
            priority_enc <= 3'b000;
            valid_b <= 1'b0;
        end
        else begin
            input_reg <= in;
            if (ready_b) begin
                priority_enc <= {~|input_reg[7:4], ~|input_reg[3:0]};
                valid_b <= 1'b1;
            end
        end
    end
    
    // Accumulator
    reg [31:0] acc_reg;
    reg [1:0] count;
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            acc_reg <= 32'b0;
            count <= 2'b00;
            ready_a <= 1'b1;
        end
        else begin
            if (valid_a && ready_a) begin
                acc_reg <= acc_reg + {24'b0, in};
                count <= count + 1'b1;
                if (count == 2'b11) begin
                    count <= 2'b00;
                    out <= acc_reg[31:22];
                    acc_reg <= 32'b0;
                    ready_a <= 1'b0;  // Must use ready_a as register
                end
            end
        end
    end
    
    // Functional Module
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            out <= 10'b0;
        end
        else begin
            if (valid_b && ready_a) begin
                out <= priority_enc + acc_reg[31:22];
                ready_a <= 1'b1;  // Must use ready_a as register
            end
        end
    end

endmodule