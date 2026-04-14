module top_module(state, counter_en, mic_en, local_rst, load_en);input wire [1:0] state;
    output reg counter_en, mic_en, local_rst, load_en;
    
    always @ (*) begin
        case (state)
            0: begin
                local_rst <= 1;
                counter_en <= 0;
                mic_en <= 0;
                load_en <= 0;
            end
            1: begin
                local_rst <= 0;
                counter_en <= 1;
                mic_en <= 1;
                load_en <= 1;
            end
            2: begin
                local_rst <= 0;
                counter_en <= 1;
                mic_en <= 1;
                load_en <= 0;
            end
        endcase
    end
endmodule