module top_module(
    input clk,
    input rst_n,
    input up_down,
    input [3:0] load_data,
    input shift_left,
    input shift_right,
    input parallel_load,
    input [3:0] data_in,
    input select,
    output reg [3:0] count,
    output reg [3:0] shift_out,  // Changed this to reg
    output reg [3:0] final_output // Changed this to reg
);reg [3:0] shift_reg;
reg [3:0] shift_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 4'b0000;
        shift_reg <= 4'b0000;
        shift_out_reg <= 4'b0000;
    end else begin
        if (up_down) begin
            if (load_data[3:0] != 4'b0000) begin
                count <= load_data[3:0];
            end else if (shift_left) begin
                count <= {count[2:0], count[3]};
            end else if (shift_right) begin
                count <= {count[1], count[3:2]};
            end else begin
                count <= count + 1;
            end
        end else begin
            if (load_data[3:0] != 4'b0000) begin
                count <= load_data[3:0];
            end else if (shift_left) begin
                count <= {count[2:0], count[3]};
            end else if (shift_right) begin
                count <= {count[1], count[3:2]};
            end else begin
                count <= count - 1;
            end
        end
        
        if (parallel_load) begin
            shift_reg <= data_in[3:0];
        end else if (shift_left) begin
            shift_reg <= {shift_reg[2:0], shift_reg[3]};
        end else if (shift_right) begin
            shift_reg <= {shift_reg[1], shift_reg[3:2]};
        end
        
        shift_out_reg <= shift_reg;
    end
end

always @(posedge clk) begin
    if (select) begin
        final_output <= count ^ shift_out_reg;
    end else begin
        final_output <= shift_out_reg;
    end
    shift_out <= shift_out_reg; // Moved this line outside of the if-else
end

endmodule