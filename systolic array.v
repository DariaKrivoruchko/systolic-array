   module dtrig 
    (
        clk, data,
        q
    );
        parameter data_size = 2;
        input wire clk;
        input wire [data_size-1:0] data;
        output reg [data_size-1:0] q;

        always @(posedge clk) 
        begin
            q = data;
        end
    endmodule 

    module mcell
        (
            clk, a_in,  b_in,  res_in, reset, m_clk,
		    a_out, b_out, res_out
        );
            parameter data_size = 2;
		    input wire reset, clk, m_clk;//m_clk is signal to write b_in to memory 
            input wire [data_size-1:0]     a_in, b_in;
            input wire [(2*data_size-1):0] res_in;
            output reg [(2*data_size-1):0] res_out;
            output reg [data_size-1:0]     a_out, b_out;
            wire       [data_size-1:0]     q;
            
            dtrig memory 
            (
                .clk(m_clk), .data(b_in), .q(q)
            );
	    	always @(posedge clk)
            begin
                if(reset)
                begin
                    a_out   = 0;
                    b_out   = 0;
                    res_out = 0;
                end
                else
		          begin
			        a_out   = a_in;
                    b_out   = q;
                    res_out = a_in * q + res_in;
		          end
            end
    endmodule

    module systolarray
    (
        clk, reset, 
        a1, a2,
        b1, b2, 
        res1, res2, res3, res4
    );
    parameter data_size  = 8;
    parameter array_size = 2;
    input wire clk, reset;
    input wire [array_size*data_size - 1:0] a, b;
    output reg [(2*array_size*data_size) - 1:0] res;
    genvar i, j;
    generate
        for(i = 0; i < array_size; i = i + 1)
        begin : strings
            for(j = 0; j < array_size; j = j + 1)
            begin : columns 
                mcell mcell_inst(
                    .clk(clk),
                    .a_in(a[data_size*j:data_size*(j+1)-1]),    
                    .b_in(b[data_size*i:data_size*(i+1)-1]),    
                    .res_in(res[data_size*i:data_size*(i+1)-1]),  
                    .reset(reset),
                    .m_clk(m_clk),   
                    .a_out(a[data_size*(j+1):data_size*(j+2)-1]), 
                    .b_out(b[data_size*(i+1):data_size*(i+2)-1]),  
                    .res_out(res[data_size*(i+1):data_size*(i+2)-1]) 
                );
            end            
        end
    endmodule
    
/*
module de10_lite
(
    input   [1:0]  KEY,
    input   [9:0]  SW,
    output  [7:0]  HEX0,
    output  [7:0]  HEX1,
    output  [7:0]  HEX2,
    output  [7:0]  HEX3,
    output  [7:0]  HEX4,
    output  [7:0]  HEX5,
    output  [9:0]  LEDR
);
  mcell mcell_inst
  (
    .clk     (SW [9]),
    .a_in    (SW [1:0]),
    .b_in    (SW [3:2]),
    .res_in  (SW [7:4]),
    .reset   (KEY [0]), 
    .m_clk   (SW [8]),
    .a_out   (LEDR [3:2]),
    .b_out   (LEDR [5:4]),
    .res_out (LEDR [9:6])
  );

endmodule */