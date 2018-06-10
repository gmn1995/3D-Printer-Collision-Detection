module CollisionDetect(
    input clk,
    input reset,
    
    input [7:0] x1,
    input [7:0] y1,
    input [7:0] z1,
    input [7:0] x2,
    input [7:0] y2,
    input [7:0] z2,
	input [7:0] x3,
    input [7:0] y3,
    input [7:0] z3,
    input [7:0] x4,
    input [7:0] y4,
    input [7:0] z4,
    output s
    
    );
	wire[3:0] o;
	wire[3:0] ons;
	
	orientation or1(x1,y1,z1,x2,y2,z2,x3,y3,z3,o[0]);
	orientation or2(x1,y1,z1,x2,y2,z2,x4,y4,z4,o[1]);
	orientation or3(x3,y3,z3,x4,y4,z4,x1,y1,z1,o[2]);
	orientation or4(x3,y3,z3,x4,y4,z4,x2,y2,z2,o[3]);
	
	onsegment os1(x1,y1,z1,x3,y3,z3,x2,y2,z2,ons[0]);
	onsegment os2(x1,y1,z1,x4,y4,z4,x2,y2,z2,ons[1]);
	onsegment os3(x3,y3,z3,x1,y1,z1,x4,y4,z4,ons[2]);
	onsegment os4(x3,y3,z3,x2,y2,z2,x4,y4,z4,ons[3]);
	
	if (o[0] != o[1] && o[2] != o[3])
        begin
		assign{s}=1;
		end
 
    // Special Cases
    // p1, q1 and p2 are colinear and p2 lies on segment p1q1
    else if (o[0] == 0 && ons[0]==1 ) 
	 begin
		assign{s}=1;
		end
	
 
    // p1, q1 and p2 are colinear and q2 lies on segment p1q1
   else if (o[1] == 0 && ons[1]==1 ) 
    begin
		assign{s}=1;
		end
 
    // p2, q2 and p1 are colinear and p1 lies on segment p2q2
    else if (o[2] == 0 && ons[2]==1 ) 
	 begin
		assign{s}=1;
		end
 
     // p2, q2 and q1 are colinear and q1 lies on segment p2q2
    else if (o[3] == 0 && ons[3]==1 ) 
	 begin
		assign{s}=1;
		end
 
    else
	begin
		assign{s}=0;
		end
	
	


endmodule

module orientation(
	input [7:0] x1,
    input [7:0] y1,
    input [7:0] z1,
    input [7:0] x2,
    input [7:0] y2,
    input [7:0] z2,
	input [7:0] x3,
    input [7:0] y3,
    input [7:0] z3,
	output [7:0]o
);

	reg[7:0] val;
	val =(y2-y1)(x3-x2)-(x2-x1)(y3-y2);
	if(val ==0)
	begin
	o=0;
	end
	
	else if(val >0)
	begin
	o=1;
	end
	
	else
	begin
	o=2;
	end
	
endmodule

module onsegment(
	input [7:0] x1,
    input [7:0] y1,
    input [7:0] z1,
    input [7:0] x2,
    input [7:0] y2,
    input [7:0] z2,
	input [7:0] x3,
    input [7:0] y3,
    input [7:0] z3,
	output [7:0]o1
);
	reg [7:0] max1;
	reg [7:0] max2;
	reg [7:0] min1;
	reg [7:0] min2;

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
	o1=1;
	end
	
	else
	begin
	o1=0;
	end
	
	
endmodule