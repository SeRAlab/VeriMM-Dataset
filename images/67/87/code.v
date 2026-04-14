module top_module(
      
	  input  wire	    avl_st_iport_0_eop,
	  input  wire[5:0]  avl_st_iport_0_error,
	  input  wire	    avl_st_iport_0_sop,
	  input  wire	    avl_st_iport_0_val,
	  input  wire[63:0] avl_st_iport_0_data,
	  input  wire[2:0]  avl_st_iport_0_empty, 
	  output reg	    avl_st_lpmx_iport_0_ready,
	  
      
	  input  wire	    avl_st_iport_1_eop,
	  input  wire[5:0]  avl_st_iport_1_error,
	  input  wire	    avl_st_iport_1_sop,
	  input  wire	    avl_st_iport_1_val,
	  input  wire[63:0] avl_st_iport_1_data,
	  input  wire[2:0]  avl_st_iport_1_empty, 
	  output reg	    avl_st_lpmx_iport_1_ready,
          input  wire	    avl_st_default_iport_1_ready, 
	  
      
      
	  output reg	    avl_st_oport_eop,
	  output reg[5:0]   avl_st_oport_error,
	  output reg	    avl_st_oport_sop,
	  output reg	    avl_st_oport_val,
	  output reg[63:0]  avl_st_oport_data,
	  output reg[2:0]   avl_st_oport_empty, 
	  input  wire	    avl_st_oport_ready, 
	  
	  input  wire	    cfg_lpmx_sel_iport_1
	);always@(*)
    begin
	if (cfg_lpmx_sel_iport_1)
	    begin
	    
	    
	    
	    
		avl_st_oport_eop  = avl_st_iport_1_eop;
		avl_st_oport_error= avl_st_iport_1_error;
		avl_st_oport_sop  = avl_st_iport_1_sop;
		avl_st_oport_val  = avl_st_iport_1_val;
		avl_st_oport_data = avl_st_iport_1_data;
		avl_st_oport_empty = avl_st_iport_1_empty; 
	        avl_st_lpmx_iport_1_ready = avl_st_oport_ready; 
	    
	    
	    
	        avl_st_lpmx_iport_0_ready = avl_st_oport_ready; 
	    end
	else 
	    begin
		avl_st_oport_eop  = avl_st_iport_0_eop;
		avl_st_oport_error= avl_st_iport_0_error;
		avl_st_oport_sop  = avl_st_iport_0_sop;
		avl_st_oport_val  = avl_st_iport_0_val;
		avl_st_oport_data = avl_st_iport_0_data;
		avl_st_oport_empty = avl_st_iport_0_empty; 
	        avl_st_lpmx_iport_0_ready = avl_st_oport_ready; 
	        avl_st_lpmx_iport_1_ready = avl_st_default_iport_1_ready; 
	    end
    end


 
 

 endmodule