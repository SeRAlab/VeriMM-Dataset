module top_module(
    input               clk         ,
    input       [7:0]   data_in     ,
    input       [2:0]   shift_amount,
    input               valid_a     ,
    input               ready_b     ,
    input               reset       ,
    
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);// Parallel Load and Shift Module
    reg [7:0] parallel_load_shift_reg;
    wire [7:0] shifted_data;

    // Shift operation using a combination of shifts based on shift_amount
    assign shifted_data = (shift_amount == 3'b000) ? parallel_load_shift_reg :
                          (shift_amount == 3'b001) ? {1'b0, parallel_load_shift_reg[7:1]} :
                          (shift_amount == 3'b010) ? {2'b00, parallel_load_shift_reg[7:2]} :
                          (shift_amount == 3'b011) ? {3'b000, parallel_load_shift_reg[7:3]} :
                          (shift_amount == 3'b100) ? {4'b0000, parallel_load_shift_reg[7:4]} :
                          (shift_amount == 3'b101) ? {5'b00000, parallel_load_shift_reg[7:5]} :
                          (shift_amount == 3'b110) ? {6'b000000, parallel_load_shift_reg[7:6]} :
                          (shift_amount == 3'b111) ? {7'b0000000, parallel_load_shift_reg[7]} : 
                          parallel_load_shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            parallel_load_shift_reg <= 8'b0;
        end else if (valid_a) begin
            parallel_load_shift_reg <= {data_in, shifted_data[7:0]};
        end
    end
    
    // Accumulate Module
    reg [7:0] accumulate_reg;
    reg [2:0] accumulate_count;

    always @(posedge clk) begin
        if (reset) begin
            accumulate_reg <= 8'b0;
            accumulate_count <= 3'b0;
            valid_b <= 1'b0; // Ensure valid_b is reset
        end else if (valid_a) begin
            accumulate_reg <= accumulate_reg + data_in;
            accumulate_count <= accumulate_count + 1;
            if (accumulate_count == 3'b111) begin
                valid_b <= 1'b1;
                data_out <= {shifted_data, accumulate_reg};
                accumulate_reg <= 8'b0;
                accumulate_count <= 3'b0;
            end
        end
    end
    
    // Output Ready Signals
    assign ready_a = !valid_a || (valid_a && ready_b);
    
    always @(posedge clk) begin
        if (reset) begin
            valid_b <= 1'b0;
            data_out <= 10'b0;
        end else if (valid_b) begin
            valid_b <= 1'b0;
        end
    end
    
endmodule