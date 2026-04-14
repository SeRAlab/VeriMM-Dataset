module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);reg [9:0]   acc;        // 10-bit accumulator
    reg [2:0]   state;      // State machine state
    reg [7:0]   data_reg;   // Input data register

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            acc <= 0;
            state <= 0;
            data_reg <= 0;
            valid_b <= 0;
            data_out <= 0;
        end else begin
            case (state)
                0: begin    // Idle state
                    if (valid_a) begin
                        data_reg <= data_in;
                        valid_b <= 1;
                        state <= 1;
                    end
                end
                1: begin    // Accumulation state
                    if (ready_b) begin
                        acc <= acc + data_reg;
                        valid_b <= 0;
                        state <= 0;
                    end
                end
            endcase
        end
    end

    assign ready_a = ~valid_b;

    always @(*) begin
        data_out = acc; // Use always block to assign to reg
    end

endmodule