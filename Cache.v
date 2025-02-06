`timescale 1ns/1ps

module Cache (
    input clk,
    input [31:0] address,
    input [127:0] inData,
	input writeSig,
    output reg [31:0] out,
    output reg hit
);

reg [153:0] cache [7:0];


initial begin 
	hit = 1;
end

always @(posedge clk) begin
	if (address[31:7] == cache[address[6:4]][152:128]) begin
		cache[address[6:4]][153] = 0;
	end
	
end

integer i;
initial begin
	i = 0;
	
end
always@(posedge clk) begin
	if (i > 3) begin
		if (address[31:7] == cache[address[6:4]][152:128] && cache[address[6:4]][153] == 1) begin
            hit = 1;
			if(address[3:2] == 0) begin
				out = cache[address[6:4]][127:96];
			end
			else if(address[3:2] == 1) begin
				out = cache[address[6:4]][95:64];
			end
			else if(address[3:2] == 2) begin
				out = cache[address[6:4]][63:32];
			end
			else if(address[3:2] == 3) begin
				out = cache[address[6:4]][31:0];
			end
        end
		if (address == 32'bx) begin
			hit = 1;
		end
        else begin
			hit = 0;
		end
	end
	else 
	begin
		i= i+1;
	end
end

always@(inData) begin
    cache[address[6:4]][153] = 1;
    cache[address[6:4]][152:128] = address[31:7];
    cache[address[6:4]][127:0] = inData;
end

endmodule