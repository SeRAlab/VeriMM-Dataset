module top_module(

clock      , 
reset      , 
req_0      , 
req_1      , 
gnt_0      , 
gnt_1
);input   clock,reset,req_0,req_1;
 output  gnt_0,gnt_1;
 wire    clock,reset,req_0,req_1;
 reg     gnt_0,gnt_1;
 parameter SIZE = 3
         ;
 parameter ST_STOP  = 2'b00,ST_FDS = 2'b01,ST_CADR = 2'b10, ST_TFR = 2'b11;

 reg   [SIZE-1:0]          state        ;
 wire  [SIZE-1:0]          next_state   ;




    assign next_state = fsm_function(state, req_0, req_1);


    function [SIZE-1:0] fsm_function;

    input  [SIZE-1:0]  state ;
    input    req_0 ;
    input    req_1 ;



    case(state)
     ST_STOP : if (req_0 == 1'b1) begin  
                  fsm_function = ST_STOP;
                end else if (req_1 == 1'b1) begin
                  fsm_function= ST_FDS;
                end else begin
                  fsm_function = ST_CADR;
                end
     ST_FDS : if (req_0 == 1'b1) begin 
                  fsm_function = ST_TFR;
                end else begin
                  fsm_function = ST_STOP;
                end
     ST_CADR : if (req_1 == 1'b1) begin  
                  fsm_function = ST_CADR;
            end else begin
                  fsm_function = ST_TFR;
                end
    ST_TFR : if(req_0 == 1'b1) begin   
                fsm_function = ST_STOP;
                end else begin
                  fsm_function = ST_TFR;
                end
    
    endcase
 endfunction





endmodule