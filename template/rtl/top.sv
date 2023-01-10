
module top (
  input  logic     i_clk ,
  output logic     o_led
);

  //------------------------------------------------------------------------------------------------
  //
  //------------------------------------------------------------------------------------------------

  logic [23:0] cnt_heartbit;

  always_ff @(posedge i_clk) begin
    cnt_heartbit <= cnt_heartbit + 1'b1;
    o_led <= cnt_heartbit[$high(cnt_heartbit)];
  end

endmodule
