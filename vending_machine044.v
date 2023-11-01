module vending_machine_044(clk, rst, in, out, change,
                   com_anode, 
                   segment, 
                   dport);

  input           clk;
  input           rst;
  input    [1:0]  in;               // 01 = 5 Rs, 10 = 10 Rs
  output reg          out;
  output reg   [1:0]  change;  // Change showing in FPGA
 output wire  [7:0]  com_anode;  // For Common Anode Selection on FPGA
 output wire  [6:0]  segment;
 output wire         dport;
 // Defining state
  parameter s0 = 2'b00; // reset
  parameter s1 = 2'b01; // 5 Rs state
  parameter s2 = 2'b10; // 10 Rs state
   
  wire u_clk;
  
  
  
  userclock               US(clk, u_clk);
 
   
  
  reg [1:0] c_state, n_state;
  
  always @(posedge u_clk)
    begin
      if(rst == 1)
        begin
          c_state <= 0;
          n_state <= 0;
        end
      else
        begin
          c_state <= n_state;
          
          case(c_state)
            
            
            s0: if(in == 0) // 	Reset State
              begin
                n_state <= s0;
                out <= 0;
                change <= 0;
              end
            else if(in == 2'b01)
              begin
                n_state <= s1;
                out <= 0;
                change <= 0;
              end
            else if(in == 2'b10)
              begin
                n_state <= s2;
                out <= 0;
                change <= 0;
              end
            
            
            s1: if(in == 0) // 5 Rs State
              begin
                n_state <= s0;
                out <= 0;
                change <= 2'b01;
              end
            else if(in == 2'b01)
              begin
                n_state <= s2;
                out <= 0;
                change <= 0;
              end
            else if(in == 2'b10)
              begin
                n_state <= s0;
                out <= 1;
                change <= 0;
              end
            
            
            s2: if(in == 0) // 10 Rs State
              begin
                n_state <= s0;
                out <= 0;
                change <= 2'b10;
              end
            else if(in == 2'b01)
              begin
                n_state <= s0;
                out <= 1;
                change <= 0;
              end
            else if(in == 2'b10)
              begin
                n_state <= s0;
                out <= 1;
                change <= 2'b01;
              end
          endcase 
         end
         end 
          
          seven_segment_display   SSD (change, segment, com_anode, dport);
      
         
   endmodule
          

         module seven_segment_display (change_1, segment_1, com_anode_1, dport_1);
            
            input  wire [1:0] change_1;
            output reg  [6:0] segment_1;
            output wire [7:0] com_anode_1;
            output  dport_1;
            
            assign com_anode_1 = 8'b11111110;
            assign     dport_1 = 0;
            
                       always @(*)
                         begin
                           case(change_1)
                             0:segment_1 = 7'b0000001;
                             1:segment_1 = 7'b0100100;
                             2:segment_1 = 7'b0010010;
                             default segment_1 = 7'b0000001;
                           endcase
                         end
            
          endmodule
          
              
   module userclock (input  clk1,output  u_clk1);
                reg clk_out = 0;
                reg [27:0] counter = 0;
                
                always @(posedge clk1)
                  begin
                        if (counter == 28'h9000000)
                          begin
                            counter <= 0;
                            clk_out <= ~clk_out;
                          end
                        else
                          begin
                            counter <= counter + 1;
                          end
                      end
                
                assign u_clk1 = clk_out;
              
         endmodule
  
           