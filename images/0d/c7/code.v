module fractional_n_pll (  
    input wire clk_ref,  
    input wire reset,  
    input wire [15:0] desired_freq,  
    input wire [15:0] ref_freq,  
    input wire [15:0] fractional_div,  
    output reg clk_out  
);  

    reg [15:0] counter;  
    reg [15:0] div_counter;  
    reg [15:0] div_value;  
    reg [31:0] divider;  

    always @(posedge clk_ref or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            div_counter <= 0;  
            clk_out <= 0;  
        end else begin  
            divider <= (desired_freq * 65536) / ref_freq; // Calculate divider
            div_value <= fractional_div + (divider >> 16); // Add the integral part

            if (div_counter < div_value) begin  
                div_counter <= div_counter + 1;  
            end else begin  
                clk_out <= ~clk_out;  
                div_counter <= 0;  
            end  

            counter <= counter + 1;  
        end  
    end  
endmodule