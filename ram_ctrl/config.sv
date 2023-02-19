`ifndef _CONFIG_SV_
`define _CONFIG_SV_

localparam integer WIDTH_RAM_CTRL_BURST_LEN = 8;
localparam integer WIDTH_RAM_CTRL_DATA      = 8;
localparam integer WIDTH_RAM_CTRL_ADDR      = 16;
localparam integer WIDTH_RAM_CTRL_INST_REQ  = 1 + WIDTH_RAM_CTRL_BURST_LEN + WIDTH_RAM_CTRL_ADDR;

`endif