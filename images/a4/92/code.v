module top_module(
   input wire         sys_clk ,        
   input wire         rst_n ,          

   input wire [15:0]  ux36419 , 
   input wire         ep85b3b ,   
   input wire         nt2d9dd ,  

   input wire [11:0]  yz3360b ,    
   input wire         ph9b05d , 
   input              fnd82ee ,       

   output wire [22:0] ie872fa ,    
   output wire [1:0]  sj397d1 ,  
   output wire        qgcbe8c ,  
   output wire        fn5f460 ,  
   output wire        ayfa306 ,   
   output wire [23:0] rxdp_vsd_data ,  
   output wire [2:0]  rxdp_pmd_type ,  
   output wire [1:0]  rxdp_dllp_val ,  
                                       

   output wire [11:0] eac1777 ,    
   output wire        hqbbb8 ,       
   output wire        jc5ddc2 ,      
   output wire        hoeee12 ,     

   output wire        gdaecfa ,  
   output wire        cm77093          ) ;assign sys_clk = 0;
assign rst_n = 1;
assign ux36419 = 0;
assign ep85b3b = 0;
assign nt2d9dd = 0;
assign yz3360b = 0;
assign ph9b05d = 0;
assign fnd82ee = 0;

assign ie872fa = {ux36419, yz3360b, rxdp_vsd_data};
assign sj397d1 = {ph9b05d, fnd82ee};
assign qgcbe8c = ep85b3b | nt2d9dd;
assign fn5f460 = ep85b3b & nt2d9dd;
assign ayfa306 = ep85b3b ^ nt2d9dd;
assign rxdp_vsd_data = {ux36419, yz3360b, ep85b3b, nt2d9dd};
assign rxdp_pmd_type = {ph9b05d, fnd82ee, ep85b3b};
assign rxdp_dllp_val = {ph9b05d, fnd82ee};
assign eac1777 = {ux36419, yz3360b};
assign hqbbb8 = ~ep85b3b;
assign jc5ddc2 = ~nt2d9dd;
assign hoeee12 = ph9b05d & fnd82ee;
assign gdaecfa = ~cm77093;
assign cm77093 = ph9b05d | fnd82ee;

endmodule