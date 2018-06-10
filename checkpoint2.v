
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
reg [7:0] lineID;
integer line_count;

initial begin
	line_count = 0;
	out_val = 0;
end

integer or1,or2,or3,or4,os1,os2,os3,os4;
// local variables for testing

always @ (posedge in_val)
begin : DETECT // Block Name
  // At every rising edge of clock we check if reset is active
  // If active, we load the counter output with 4'b0000
reg [7:0] l1memx[100:0] ;
reg [7:0] l1memy[100:0];
reg [7:0] l1memz[100:0];
reg [7:0] l2memx[100:0] ;
reg [7:0] l2memy[100:0];
reg [7:0] l2memz[100:0];
	if (in_val == 1 )
	begin
		
		l1memx[line_count]=x1;
		l1memy[line_count]=y1;
		l1memz[line_count]=z1;
		
		l2memx[line_count]=x2;
		l2memy[line_count]=y2;
		l2memz[line_count]=z2;
		
		line_count = line_count + 1;
		lineID = line_count;
		
		// if line id is even then write to the result file
		
	end
end  // End of Block COUNTER

//-----------------------------------------CHECKING HERE----------------------------------------------------------------------------------
always @ (*)
begin : DETECT // Block Name
  // At every rising edge of clock we check if reset is active
  // If active, we load the counter output with 4'b0000

	for  (i =0;i<line_count-1;i=i+1)
	lineID=i;
	begin
	
		for (j=i+1;j<line_count;j=j+1)
		begin
		
			if(collision_detected(l1memx[i],l1memy[i],l1memz[i],l2memx[i],l2memy[i],l2memz[i],l1memx[j],l1memy[j],l1memz[j],l2memx[j],l2memy[j],l2memz[	j])==1)
				begin 
				 $display ("line ID %d",lineID);
				
				end
		
		end
		
	end
end  // End of Block COUNTER
//----------------------------------------------------------------------------------------------------------------------------------------------------





function collision_detected;
input [7:0] x1,y1,z1,x2,y2,z2,x3,y3,z3, x4,y4,z4;

integer or1,or2,or3,or4,os1,os2,os3,os4;
 
begin
or1 = orientation(x1,y1,z1,x2,y2,z2,x3,y3,z3);
or2=orientation(x1,y1,z1,x2,y2,z2,x4,y4,z4);
or3=orientation(x3,y3,z3,x4,y4,z4,x1,y1,z1);
or4=orientation(x3,y3,z3,x4,y4,z4,x2,y2,z2);

os1=onsegment (x1,y1,z1,x3,y3,z3,x2,y2,z2);
os2=onsegment (x1,y1,z1,x4,y4,z4,x2,y2,z2);
os3=onsegment(x3,y3,z3,x1,y1,z1,x4,y4,z4);
os4=onsegment(x3,y3,z3,x2,y2,z2,x4,y4,z4);


if (or1 != or2 && or3 != or4)
  begin
		{collision_detected}=1;
  end
		
  else if (or1 == 0 && os1==1 ) 
  begin
		{collision_detected}=1;
  end
  
  else if (or2 == 0 && os2==1 ) 
  begin
		{collision_detected}=1;
  end
 
  // p2, q2 and p1 are colinear and p1 lies on segment p2q2
  else if (or3 == 0 && os3==1 ) 
  begin
		{collision_detected}=1;
	end
 
     // p2, q2 and q1 are colinear and q1 lies on segment p2q2
    else if (or4 == 0 && os4==1 ) 
	 begin
		{collision_detected}=1;
		end
 
    else
	begin
		{collision_detected}=0;
	end
	
endfunction 

/* always @ (posedge clock)
begin : DETECT // Block Name
  // At every rising edge of clock we check if reset is active
  // If active, we load the counter output with 4'b0000
  
  
  
end */ // End of Block COUNTER


// functions starts here

function integer onsegment;
input [7:0] x1,y1,z1,x2,y2,z2,x3,y3,z3;
integer max1,max2, min1,min2;
begin	
	 
	if (x1>=x3)
	begin
	max1=x1;
	min1=x3;
	end
	
	else 
	begin
	max1=x3;
	min1=x1;
	end
	
	if (y1>=y3)
	begin
	max2=y1;
	min2=y3;
	end
	
	else 
	begin
	max2=y3;
	min2=y1;
	end
	
	if(x2<=max1 && x2>= min1 && y2<=max2 && y2>=min2)
	begin
	onsegment=1;
	end
	
	else
	begin
	onsegment=0;
	end
end
endfunction

function integer orientation;
	 
input [7:0] x1,y1,z1,x2,y2,z2,x3,y3,z3;
integer val;	
begin
		
	val =(y2-y1)*(x3-x2)-(x2-x1)*(y3-y2);
	// $display ("\n val is  %d",val);
	
	if(val == 0)
	begin
		orientation=0;	
	end
	else if (val > 0)
	begin
		orientation=1;
	end
	else
	begin
		orientation=2;
	end
end
endfunction




endmodule

