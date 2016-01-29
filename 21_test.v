module mybram #(parameter LOGSIZE=5, WIDTH=16)
    (input wire clk,
    input wire [LOGSIZE-1:0] addr,
    input wire [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout,
    input wire we);
  reg [WIDTH-1:0] mem[LOGSIZE-1:0];
  always @(posedge clk) begin
    if (we) mem[addr] <= din;
    dout <= mem[addr];
  end
endmodule

module SPI #(parameter OP_MODE=1)
    (input clk,
    input wire din,
    output reg dout);
  reg [4:0]addr;
  reg [4:0]counter = 0;
  reg we = 0;
  reg write;
  reg [15:0]data;
  reg [15:0]memin;
  wire [15:0]memout;
  mybram #(.LOGSIZE(5),.WIDTH(16))
		mybram1(.clk(clk),.addr(addr),.din(memin),.dout(memout),.we(we));
		
  always @(posedge clk) begin
    if (OP_MODE == 0) begin
      if (counter < 5) begin
        we <= 0;
        addr[0] <= din;
        addr[4:1] <= addr[3:0];
        counter <= counter + 1;
      end
      
      else if (counter == 5) begin
        write <= din;
        counter <= counter + 1;
      end
      
      else if (counter > 7) begin
        if (write) begin
          if (counter < 24) begin
            data[0] <= din;
            data[15:1] <= data[14:0];
            counter <= counter + 1;
          end
          else if (counter == 24) begin
            memin <= data;
            we <= 1;
            counter <= 0;
          end
        end
      
        else begin
          if (counter < 24) begin
            dout <= memout[23-counter];
          end
          else if (counter == 24) begin
            counter <= 0;
          end
        end
      end
    end
  end
endmodule
