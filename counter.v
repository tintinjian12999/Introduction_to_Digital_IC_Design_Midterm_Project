module counter(out, clk, rst, in);
	input clk;
	input rst; 
	input [1:0] in;
	output reg [3:0]out;
	reg [3:0]next_out;
	reg [2:0]state;
	reg [2:0]next_state;
  reg overflow;
//state register
always@(posedge clk or posedge rst)
begin
    if(rst == 1) state = 3;
    else
    begin
      state = next_state;
      case(state)
      0:  next_out = out;
      1:
      begin
        if(out + in > 15)
        begin
         next_out = 15;
         overflow = 1;
        end
        else
        begin
          next_out = out + in;
          overflow = 0;
        end
      end
      2:
      begin
        if(in > out)
        begin
          overflow = 1;
          next_out = 0;
        end
        else
        begin
         next_out = out - in;
         overflow = 0;
        end
      end
      default:  next_out = 0;
      endcase
    end
end
//next state logic
always@(*)
begin
    case(state)
    // state = 0 -> hold, state = 1 -> plus, state = 2 -> minus, state = 3 -> reset
     0:begin
        if(next_out == 0)    next_state = 1;
        else if(next_out == 15)    next_state = 2;
        else next_state = 0;
       end
     1:begin
        if(next_out == 15 && overflow == 0)  next_state = 0;
        else if (next_out == 15 && overflow == 1)  next_state = 2;
        else next_state = 1;
       end
     2:begin
        if(next_out == 0 && overflow == 0) next_state = 0;
        else if(next_out == 0 && overflow == 1)  next_state = 1;
        else next_state = 2;
       end
     3:begin
        next_state = 1;
       end
     endcase
end
//output logic
always@(*)
begin
  if(state == 3)  out = 0;
  else out = next_out;
end
endmodule