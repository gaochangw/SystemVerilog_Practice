`ifndef _CONFIG_SV_
`define _CONFIG_SV_

localparam integer WIDTH_RAM_CTRL_TYPE      = 1;
localparam integer WIDTH_RAM_CTRL_BURST_LEN = 8;
localparam integer WIDTH_RAM_CTRL_ADDR      = 16;
localparam integer WIDTH_RAM_CTRL_INST_REQ  = WIDTH_RAM_CTRL_TYPE + WIDTH_RAM_CTRL_BURST_LEN + WIDTH_RAM_CTRL_ADDR;

typedef enum logic {1: READ, 0:WRITE} REQ_TYPE;

`endif