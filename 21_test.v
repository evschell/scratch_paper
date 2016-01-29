module mybram #(parameter LOGSIZE=5, WIDTH=16)
    (input wire [LOGSIZE-1:0] addr,
    input wire [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout,
    input wire we);
  reg [WIDTH-1:0] mem[LOGSIZE-1:0];
  always @(addr) begin
    if (we) mem[addr] <= din;
    dout <= mem[addr];
  end
endmodule

module SPI #(parameter OP_MODE=1)
    (input wire din,
    output reg dout);
  reg [4:0]addr;
  reg [4:0]counter = 0;
  reg we;
  reg [15:0]data;
  mybram #(.LOGSIZE(5),.WIDTH(16))
		mybram1(.addr(addr),.din(memin),.dout(memout),.we(we));
		
  always @(din) begin
    if (OP_MODE == 0) begin
      if (counter < 5) begin
        addr[0] <= din;
        addr[4:1] <= addr[3:0];
        counter <= counter + 1;
      end
      else if (counter == 5) begin
        we <= din;
        counter <= counter + 1;
      end
      else if (counter < 24) begin
        if (we) begin
          data[0] <= din;
          data[15:1] <= din[14:0];
        end
        else
          
        end
      end
    end
  end
