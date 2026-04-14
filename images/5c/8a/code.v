module top_module( max, q, clk, rst ) ;parameter   size_cnt = 8 ;
    input   [size_cnt-1:0]          max ;
    output                          q ;
    input                           clk ;
    input                           rst ;
    reg                             q ;

    reg     [size_cnt-1:0]          cnt ;
    
    
    always  @( posedge clk or posedge rst )
        if ( rst )
            cnt <= 0 ;
        else
            if ( cnt == 0 )
                cnt <= max ;                        
            else
                cnt <= cnt - 1 ;

    
    always  @( posedge clk )
        if ( cnt == 1 )
            q <= 'b1 ;
        else
            q <= 'b0 ;endmodule