`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Bus_RNW_reg;
    reg E;
    reg [7:0] Q;
    reg [27:0] ce_out_i_reg;
    reg ext_spi_clk;
    reg ip2Bus_RdAck_core_reg_reg;
    reg [7:0] p_5_in;
    reg rx_fifo_empty_i_reg;
    reg rx_fifo_reset;
    reg s_axi_aclk;
    reg scndry_out;
    reg spiXfer_done_int;
    wire [24:0] IP2Bus_Data_reg;
    wire Receive_ip2bus_error0;
    wire Rx_FIFO_Full_Fifo;
    wire Rx_FIFO_Full_Fifo_d1_reg;
    wire [3:0] icount_out_reg;
    wire [7:0] out;
    wire ram_full_fb_i_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Bus_RNW_reg(Bus_RNW_reg),
        .E(E),
        .Q(Q),
        .ce_out_i_reg(ce_out_i_reg),
        .ext_spi_clk(ext_spi_clk),
        .ip2Bus_RdAck_core_reg_reg(ip2Bus_RdAck_core_reg_reg),
        .p_5_in(p_5_in),
        .rx_fifo_empty_i_reg(rx_fifo_empty_i_reg),
        .rx_fifo_reset(rx_fifo_reset),
        .s_axi_aclk(s_axi_aclk),
        .scndry_out(scndry_out),
        .spiXfer_done_int(spiXfer_done_int),
        .IP2Bus_Data_reg(IP2Bus_Data_reg),
        .Receive_ip2bus_error0(Receive_ip2bus_error0),
        .Rx_FIFO_Full_Fifo(Rx_FIFO_Full_Fifo),
        .Rx_FIFO_Full_Fifo_d1_reg(Rx_FIFO_Full_Fifo_d1_reg),
        .icount_out_reg(icount_out_reg),
        .out(out),
        .ram_full_fb_i_reg(ram_full_fb_i_reg)
    );

    // Clock generation (10ns period)
    initial begin
        ext_spi_clk = 0;
        forever #5 ext_spi_clk = ~ext_spi_clk;
    end

        task reset_dut;

        begin
            rx_fifo_reset = 1;
            Bus_RNW_reg = 0;
            E = 0;
            Q = 8'h00;
            ce_out_i_reg = 28'h0;
            ip2Bus_RdAck_core_reg_reg = 0;
            p_5_in = 8'h00;
            rx_fifo_empty_i_reg = 1;
            spiXfer_done_int = 0;
            scndry_out = 0;
            repeat (5) @(posedge s_axi_aclk);
            rx_fifo_reset = 0;
            repeat (2) @(posedge s_axi_aclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase %03d: Reset State Verification", test_num);



            #1;




            check_outputs(25'h0, 1'b0, 1'b0, 1'b0, 4'h0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase %03d: Data Forwarding (E=1)", test_num);

            @(posedge s_axi_aclk);
            E = 1;
            Q = 8'hA5;
            repeat (2) @(posedge s_axi_aclk);


            #1;



            check_outputs(25'h0, 1'b0, 1'b0, 1'b0, 4'h0, 8'hA5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase %03d: FIFO Full Status", test_num);

            @(posedge s_axi_aclk);
            p_5_in = 8'hFF;
            rx_fifo_empty_i_reg = 0;
            repeat (5) @(posedge s_axi_aclk);



            #1;




            check_outputs(25'h0, 1'b0, 1'b1, 1'b1, 4'h0, 8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase %03d: icount Increment", test_num);

            @(posedge s_axi_aclk);
            rx_fifo_empty_i_reg = 0;
            spiXfer_done_int = 1;
            repeat (4) @(posedge ext_spi_clk);


            #1;



            check_outputs(25'h0, 1'b0, 1'b0, 1'b0, 4'h4, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running Testcase %03d: Bus Read and Error Check", test_num);

            @(posedge s_axi_aclk);
            Bus_RNW_reg = 1;
            ip2Bus_RdAck_core_reg_reg = 1;
            ce_out_i_reg = 28'h0000001;
            p_5_in = 8'h55;

            repeat (2) @(posedge s_axi_aclk);



            #1;




            check_outputs(25'h0000055, 1'b0, 1'b0, 1'b0, 4'h0, 8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Running Testcase %03d: Multi-Clock Domain Interaction", test_num);

            @(posedge ext_spi_clk);
            scndry_out = 1;
            Q = 8'h3C;
            E = 1;
            @(posedge s_axi_aclk);

            repeat (5) @(posedge s_axi_aclk);


            #1;



            check_outputs(25'h0, 1'b0, 1'b0, 1'b0, 4'h0, 8'h3C, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [24:0] expected_IP2Bus_Data_reg;
        input expected_Receive_ip2bus_error0;
        input expected_Rx_FIFO_Full_Fifo;
        input expected_Rx_FIFO_Full_Fifo_d1_reg;
        input [3:0] expected_icount_out_reg;
        input [7:0] expected_out;
        input expected_ram_full_fb_i_reg;
        begin
            if (expected_IP2Bus_Data_reg === (expected_IP2Bus_Data_reg ^ IP2Bus_Data_reg ^ expected_IP2Bus_Data_reg) &&
                expected_Receive_ip2bus_error0 === (expected_Receive_ip2bus_error0 ^ Receive_ip2bus_error0 ^ expected_Receive_ip2bus_error0) &&
                expected_Rx_FIFO_Full_Fifo === (expected_Rx_FIFO_Full_Fifo ^ Rx_FIFO_Full_Fifo ^ expected_Rx_FIFO_Full_Fifo) &&
                expected_Rx_FIFO_Full_Fifo_d1_reg === (expected_Rx_FIFO_Full_Fifo_d1_reg ^ Rx_FIFO_Full_Fifo_d1_reg ^ expected_Rx_FIFO_Full_Fifo_d1_reg) &&
                expected_icount_out_reg === (expected_icount_out_reg ^ icount_out_reg ^ expected_icount_out_reg) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_ram_full_fb_i_reg === (expected_ram_full_fb_i_reg ^ ram_full_fb_i_reg ^ expected_ram_full_fb_i_reg)) begin
                $display("PASS");
                $display("  Outputs: IP2Bus_Data_reg=%h, Receive_ip2bus_error0=%b, Rx_FIFO_Full_Fifo=%b, Rx_FIFO_Full_Fifo_d1_reg=%b, icount_out_reg=%h, out=%h, ram_full_fb_i_reg=%b",
                         IP2Bus_Data_reg, Receive_ip2bus_error0, Rx_FIFO_Full_Fifo, Rx_FIFO_Full_Fifo_d1_reg, icount_out_reg, out, ram_full_fb_i_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IP2Bus_Data_reg=%h, Receive_ip2bus_error0=%b, Rx_FIFO_Full_Fifo=%b, Rx_FIFO_Full_Fifo_d1_reg=%b, icount_out_reg=%h, out=%h, ram_full_fb_i_reg=%b",
                         expected_IP2Bus_Data_reg, expected_Receive_ip2bus_error0, expected_Rx_FIFO_Full_Fifo, expected_Rx_FIFO_Full_Fifo_d1_reg, expected_icount_out_reg, expected_out, expected_ram_full_fb_i_reg);
                $display("  Got:      IP2Bus_Data_reg=%h, Receive_ip2bus_error0=%b, Rx_FIFO_Full_Fifo=%b, Rx_FIFO_Full_Fifo_d1_reg=%b, icount_out_reg=%h, out=%h, ram_full_fb_i_reg=%b",
                         IP2Bus_Data_reg, Receive_ip2bus_error0, Rx_FIFO_Full_Fifo, Rx_FIFO_Full_Fifo_d1_reg, icount_out_reg, out, ram_full_fb_i_reg);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,Bus_RNW_reg, E, Q, ce_out_i_reg, ext_spi_clk, ip2Bus_RdAck_core_reg_reg, p_5_in, rx_fifo_empty_i_reg, rx_fifo_reset, s_axi_aclk, scndry_out, spiXfer_done_int, IP2Bus_Data_reg, Receive_ip2bus_error0, Rx_FIFO_Full_Fifo, Rx_FIFO_Full_Fifo_d1_reg, icount_out_reg, out, ram_full_fb_i_reg);
    end

endmodule
