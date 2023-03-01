module tb_booth_mul ();
localparam int unsigned WIDTH        = 32;
localparam int unsigned NUM_OPERANDS = 3;
   
   wire clk_i;
   wire rst_ni;
   wire [NUM_OPERANDS-1:0][WIDTH-1:0] operands_i;
   wire  [47:0] product;

      		     
   clk_gen CG(.END_SIM(end_sim),
              .CLK(clk_i),
              .RST_n(rst_ni));
		    	       
   booth_mul DUT(
			 .mantissa_a(24'h800000),
			 .mantissa_b(24'hF00000),
			 .product(product));		 
   
endmodule
