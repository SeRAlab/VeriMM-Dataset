module top_module(

    input [2:0] visor_x,
    input [1:0] visor_y,
    output reg [7:0] valor,
    output reg is_number
    );always @(*) begin
            case ({visor_x,visor_y})
            {3'd0 ,2'd0}: {valor,is_number}={8'b0,1'b1};
            {3'd1 ,2'd0}: {valor,is_number}={8'b1,1'b1};
            {3'd2 ,2'd0}: {valor,is_number}={8'd2,1'b1};
            {3'd3 ,2'd0}: {valor,is_number}={8'd3,1'b1};
            {3'd4 ,2'd0}: {valor,is_number}={8'd16,1'b0};    
            {3'd5 ,2'd0}: {valor,is_number}={8'd17,1'b0};    
            {3'd0 ,2'd1}: {valor,is_number}={8'd4,1'b1};
            {3'd1 ,2'd1}: {valor,is_number}={8'd5,1'b1};
            {3'd2 ,2'd1}: {valor,is_number}={8'd6,1'b1};
            {3'd3 ,2'd1}: {valor,is_number}={8'd7,1'b1};
            {3'd4 ,2'd1}: {valor,is_number}={8'd18,1'b0};    
            {3'd5 ,2'd1}: {valor,is_number}={8'd19,1'b0};    
            {3'd0 ,2'd2}: {valor,is_number}={8'd8,1'b1};
            {3'd1 ,2'd2}: {valor,is_number}={8'd9,1'b1};
            {3'd2 ,2'd2}: {valor,is_number}={8'h0a,1'b1};
            {3'd3 ,2'd2}: {valor,is_number}={8'h0b,1'b1};
            {3'd4 ,2'd2}: {valor,is_number}={8'd20,1'b0};    
            {3'd5 ,2'd2}: {valor,is_number}={8'd21,1'b0};    
            {3'd0 ,2'd3}: {valor,is_number}={8'h0c,1'b1};
            {3'd1 ,2'd3}: {valor,is_number}={8'h0d,1'b1};
            {3'd2 ,2'd3}: {valor,is_number}={8'h0e,1'b1};
            {3'd3 ,2'd3}: {valor,is_number}={8'h0f,1'b1};
            {3'd4 ,2'd3}: {valor,is_number}={8'd22,1'b0};    
            default: {valor,is_number}={8'd28,1'b0};
            endcase
        end
endmodule