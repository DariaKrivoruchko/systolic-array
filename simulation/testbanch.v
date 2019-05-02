`timescale 1 ns / 100 ps

module tesybanch;
    parameter data_size = 2;
    reg reset, clk, m_clk;
    reg  [data_size-1:0] a_in,  b_in;
    wire [data_size-1:0] a_out, b_out;
    reg  [2*data_size-1:0] res_in;
    wire [2*data_size-1:0] res_out;


     mcell mcell_inst
    (
        reset, clk, m_clk,
        a_in,  b_in,
        a_out, b_out,
        res_in,
        res_out
    );
    initial
        begin
           reset  = 0;
           clk    = 0;
           m_clk  = 0;
           a_in   = 2'b10;
           b_in   = 2'b01;
           res_in = 4'b0100;
           #10;
           m_clk  = 1;
           clk    = 1;
           #10; 
           clk    = 0;
           m_clk  = 0;
           a_in   = 2'b01;
           b_in   = 2'b11;
           #10;
           clk    = 1;
           #10;
           clk    = 0;          
        end
   initial 
        $monitor("reset=%b clk=%b m_clk=%b a_in=%b b_in=%b a_out=%b b_out=%b res_in=%b res_out=%b",reset, clk, m_clk, a_in, b_in, a_out, b_out, res_in, res_out);
    initial 
        $dumpvars; 
endmodule