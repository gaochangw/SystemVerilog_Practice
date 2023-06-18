`timescale 1ps/1ps
`include "config.sv"

module ram_ctrl #(
    parameter RAM_WIDTH    = 8,
    parameter RAM_DEPTH    = 256,
    parameter N_REQUESTORS = 2
) (
    input  logic                                                 clk,   // Clock
    input  logic                                                 rst_n, // Active Low
    // Write Request Channels
    input  logic [N_REQUESTORS-1:0]                              s_wreq_axis_tvalid_i,
    input  logic [N_REQUESTORS-1:0][WIDTH_RAM_CTRL_INST_REQ-1:0] s_wreq_axis_tdata_i,
    input  logic [N_REQUESTORS-1:0]                              s_wreq_axis_tlast_i,
    input  logic [N_REQUESTORS-1:0]                              s_wreq_axis_tready_o,
    // Write Data Channels
    input  logic [N_REQUESTORS-1:0]                              s_wdata_axis_tvalid_i,
    input  logic [N_REQUESTORS-1:0][RAM_WIDTH-1:0]               s_wdata_axis_tdata_i,
    input  logic [N_REQUESTORS-1:0]                              s_wdata_axis_tlast_i,
    input  logic [N_REQUESTORS-1:0]                              s_wdata_axis_tready_o,
    // Read Request Channels
    input  logic [N_REQUESTORS-1:0]                              s_rreq_axis_tvalid_i,
    input  logic [N_REQUESTORS-1:0][WIDTH_RAM_CTRL_INST_REQ-1:0] s_rreq_axis_tdata_i,
    input  logic [N_REQUESTORS-1:0]                              s_rreq_axis_tlast_i,
    input  logic [N_REQUESTORS-1:0]                              s_rreq_axis_tready_o,
    // Read Data Channels
    input  logic [N_REQUESTORS-1:0]                              m_rdata_axis_tvalid_o,
    input  logic [N_REQUESTORS-1:0][RAM_WIDTH-1:0]               m_rdata_axis_tdata_o,
    input  logic [N_REQUESTORS-1:0]                              m_rdata_axis_tlast_o,
    input  logic [N_REQUESTORS-1:0]                              m_rdata_axis_tready_i
);

    ram_sp (
        .WIDTH (RAM_WIDTH),
        .DEPTH (RAM_DEPTH),
    ) i_ram (
        .clk  (),
        .din  (),
        .addr (),
        .cen  (),
        .wen  (),  // Active Low
        .dout ()
);
endmodule