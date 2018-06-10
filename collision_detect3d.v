`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:34:53 03/25/2017 
// Design Name: 
// Module Name:    collision_detect 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CollisionDetect(
	clk,
   reset,
   in_val,
   x1,
   y1,
   z1,
   x2,
   y2,
   z2,
   out_val,
   lineID	
);

input clk;
input reset;

input in_val;
input x1;
input y1;
input z1;
input x2;
input y2;
input z2;

output out_val;
output lineID;

// By rule all the input ports should be wires
wire [7:0] x1;
wire [7:0] y1;
wire [7:0] z1;
wire [7:0] x2;
wire [7:0] y2;
wire [7:0] z2;

reg out_val;
reg detect;
reg [7:0] lineID;
integer line_count;
integer i;

initial begin
	line_count = 0;
	out_val = 0;
	detect = 0;
	lineID = 2;
	i = 1;
end

reg [7:0] memx1[10:0];
reg [7:0] memy1[10:0];
reg [7:0] memz1[10:0];
reg [7:0] memx2[10:0];
reg [7:0] memy2[10:0];
reg [7:0] memz2[10:0];

// local variables for testing

always @ (posedge clk )
begin : DETECT
	// $display ("\n %d %d %d",line_count,lineID,i); 
	if (line_count > 8 && lineID <= line_count )
	begin
		if ( memz1[lineID] == memz1[i] && i != lineID )
		begin
			$display ("\n Compare Line %d with %d ",lineID,i); 
			out_val = collision_detected(memx1[lineID],memy1[lineID],memz1[lineID],memx2[lineID],memy2[lineID],memz2[lineID],memx1[i],memy1[i],memz1[i],memx2[i],memy2[i],memz2[i]);
			$display ("\n out_val is %d",out_val);
		end
		else
		begin
			out_val = 0;
		end
		if ( i < lineID )
		begin
			i = i + 1;
		end
		else
		begin
			i = 1;
			lineID = lineID + 1;
		end
	end
end

always @ (posedge in_val)
begin : READ // Block Name
  // At every rising edge of clock we check if reset is active
  // If active, we load the counter output with 4'b0000
	if (in_val == 1 )
	begin
		line_count = line_count + 1;
		// lineID = line_count;
		// $display ("\n In Val is %d",in_val);
		// $display ("\n Line Id is %d",lineID);
		// $display ("\n line_count Id is %d",line_count);
		// $display ("\n %d %d %d %d %d %d",x1,y1,z1,x2,y2,z2);
		
		memx1[line_count]=x1;
		memy1[line_count]=y1;
		memz1[line_count]=z1;
		
		memx2[line_count]=x2;
		memy2[line_count]=y2;
		memz2[line_count]=z2;
		
		// if line id is even then write to the result file
		/*
		if (line_count % 2 == 0 )
		begin
			out_val = 1;
			$display ("\n ******************** Line Id is %d",lineID);
		end
		else
		begin
			out_val = 0;
		end
		*/
	end
end  // End of Block COUNTER


// functions starts here

function collision_detected;
	input [7:0] x1,y1,z1,x2,y2,z2,x3,y3,z3, x4,y4,z4;
   
	integer t1,t2;
	reg [7:0] dir1 [0:2];
	reg [7:0] dir2 [0:2];
 
	begin
		dir1[0]=x2-x1;
		dir1[1]=y2-y1;
		dir1[2]=z2-z1;
		
		dir2[0]=x4-x3;
		dir2[1]=y4-y3;
		dir2[2]=z4-z3;


	  t1=x(dir1[0],-dir2[0],x3-x1,dir1[1],-dir2[1],y3-y1);
	  t2=y(dir1[0],-dir2[0],x3-x1,dir1[1],-dir2[1],y3-y1);
	  
	  if(x1+dir1[0]*t1==x3+dir2[0]*t2 && y1+dir1[1]*t1==y3+dir2[1]*t2 && z1+dir1[2]*t1==z3+dir2[2]*t2)
		begin
			{collision_detected}=1;
		end
		
	  else 
		begin
			{collision_detected}=0;
		end
	  
	end
	
endfunction 


function integer x;
input [7:0] a1,b1,c1,a2,b2,c2;

begin	
	x=(b2*c1-b1*c2)/(b2*a1-b1*a2) 
	
end
endfunction

function integer y;
input [7:0] a1,b1,c1,a2,b2,c2;

begin	
	y=(a2*c1-a1*c2)/(a2*b1-a1*b2) 
	
end
endfunction

function integer div;
input [7:0] num,den;

begin	
	for(int i=1;i<num;i++)
	begin
	if(den*i> num)
	begin
	i=i-1;
	break;
	
	end
	end
	
end
endfunction


endmodule

