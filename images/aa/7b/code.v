module top_module(input a, input b, output y);parameter p = 2, q = 4;
  
  
  
  
  
  

  if (p == 1)
    if (q == 0)
      begin : u1
        
        assign y = a & b;
        
      end
    else if (q == 2)
      begin : u1
      
        assign y = a | b;
      
      end
    else
      begin :u1
        assign y = a ~& b;
      end
  else
    begin : u2
      case (q)
        0, 1, 2:
          begin : u1
            
            assign y = a ^ b;
          end
        default:
          begin : u1
            
            assign y = a ~^ b;
          end
      endcase
    end

endmodule