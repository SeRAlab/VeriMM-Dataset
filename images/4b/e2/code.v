module top_module(
    input clk_i,
    input rst_i,
    input ins_i,
    input [2:0] icm_bi,
    output reg ins_o 
    );reg prev_ins;
    wire rising_edge = ins_i && !prev_ins;
    wire falling_edge = !ins_i && prev_ins;
    
    wire enable_rising_edge = rising_edge && (icm_bi == 'h1 || icm_bi == 'h3 || icm_bi == 'h4 || icm_bi == 'h5);
    wire enable_falling_edge = falling_edge && (icm_bi == 'h1 || icm_bi == 'h2 || icm_bi == 'h6 || icm_bi == 'h7);
    wire signal = (icm_bi != 0) && (enable_rising_edge || enable_falling_edge);
    
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            prev_ins <= 0;
        end
        else begin
            prev_ins <= ins_i;
            ins_o <= signal;
        end
    end
    
endmodule