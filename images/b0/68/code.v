module top_module(s,cout,a,b,c);input a,b,c;
  output s,cout;
  
  assign s = sum (a,b,c);
  assign cout = carry (a,b,c);
  
function sum; 
			  
  input x,y,z;
  begin
    sum = x ^ y ^ z;
  end
endfunction

function carry;
  input x,y,z;
  begin
    carry = (x&y) | (y&z) | (x&z);
  end
endfunction

endmodule