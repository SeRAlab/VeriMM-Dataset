module top_module(input  MM,HH,input  sel,output  up60, up24, up60sv, up24sv);assign up60= sel==0?MM:0;
     assign up24= sel==0?HH:0;
     
     assign up60sv=sel==1?MM:0;
     assign up24sv=sel==1?HH:0;
    
endmodule