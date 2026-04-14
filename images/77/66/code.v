module top_module(

    input [1:0] gpio_sel,  

    input tri_i_out,   
    output reg tri_o_out,   
    output reg tri_t_out,   
    



    
    output tri_i_in,   
    input tri_o_in,    
    input tri_t_in,    
    


    
    output sda_i_in,  
    input sda_o_in,   
    input sda_t_in,   
    output scl_i_in,  
    input scl_o_in,   
    input scl_t_in    
    );reg [2:0] tri_i_out_demux;
    assign {scl_i_in,sda_i_in, tri_i_in} = tri_i_out_demux;
    



    always @(gpio_sel, tri_o_in, scl_o_in, sda_o_in)
       case (gpio_sel)
          2'h0: tri_o_out = tri_o_in;   
          2'h1: tri_o_out = tri_o_in;   
          2'h2: tri_o_out = sda_o_in;   
          2'h3: tri_o_out = scl_o_in;   
       endcase

    always @(gpio_sel, tri_i_out)
    begin
       tri_i_out_demux = {3{1'b0}};
       case (gpio_sel)
          2'h0: tri_i_out_demux[0] = tri_i_out;     
          2'h1: tri_i_out_demux[0] = tri_i_out;     
          2'h2: tri_i_out_demux[1] = tri_i_out;     
          2'h3: tri_i_out_demux[2] = tri_i_out;     
       endcase
    end

    always @(gpio_sel, tri_t_in, scl_t_in, sda_t_in)
       case (gpio_sel)
          2'h0: tri_t_out = tri_t_in;   
          2'h1: tri_t_out = tri_t_in;   
          2'h2: tri_t_out = sda_t_in;   
          2'h3: tri_t_out = scl_t_in;   
       endcase

endmodule