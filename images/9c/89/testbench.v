`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ao486_rst;
    reg [31:0] bios_loader_address;
    reg [3:0] bios_loader_byteenable;
    reg bios_loader_read;
    reg bios_loader_write;
    reg [31:0] bios_loader_writedata;
    reg clk_sys;
    reg [31:0] driver_sd_avs_readdata;
    reg [31:0] hdd_avalon_master_address;
    reg hdd_avalon_master_read;
    reg hdd_avalon_master_write;
    reg [31:0] hdd_avalon_master_writedata;
    reg rst;
    wire [31:0] bios_loader_readdata;
    wire bios_loader_waitrequest;
    wire [1:0] driver_sd_avs_address;
    wire driver_sd_avs_read;
    wire driver_sd_avs_write;
    wire [31:0] driver_sd_avs_writedata;
    wire [31:0] hdd_avalon_master_readdata;
    wire hdd_avalon_master_readdatavalid;
    wire hdd_avalon_master_waitrequest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ao486_rst(ao486_rst),
        .bios_loader_address(bios_loader_address),
        .bios_loader_byteenable(bios_loader_byteenable),
        .bios_loader_read(bios_loader_read),
        .bios_loader_write(bios_loader_write),
        .bios_loader_writedata(bios_loader_writedata),
        .clk_sys(clk_sys),
        .driver_sd_avs_readdata(driver_sd_avs_readdata),
        .hdd_avalon_master_address(hdd_avalon_master_address),
        .hdd_avalon_master_read(hdd_avalon_master_read),
        .hdd_avalon_master_write(hdd_avalon_master_write),
        .hdd_avalon_master_writedata(hdd_avalon_master_writedata),
        .rst(rst),
        .bios_loader_readdata(bios_loader_readdata),
        .bios_loader_waitrequest(bios_loader_waitrequest),
        .driver_sd_avs_address(driver_sd_avs_address),
        .driver_sd_avs_read(driver_sd_avs_read),
        .driver_sd_avs_write(driver_sd_avs_write),
        .driver_sd_avs_writedata(driver_sd_avs_writedata),
        .hdd_avalon_master_readdata(hdd_avalon_master_readdata),
        .hdd_avalon_master_readdatavalid(hdd_avalon_master_readdatavalid),
        .hdd_avalon_master_waitrequest(hdd_avalon_master_waitrequest)
    );

    // Clock generation (10ns period)
    initial begin
        clk_sys = 0;
        forever #5 clk_sys = ~clk_sys;
    end

        task reset_dut;

        begin
            rst = 1;
            ao486_rst = 0;
            bios_loader_address = 0;
            bios_loader_byteenable = 4'hf;
            bios_loader_read = 0;
            bios_loader_write = 0;
            bios_loader_writedata = 0;
            driver_sd_avs_readdata = 0;
            hdd_avalon_master_address = 0;
            hdd_avalon_master_read = 0;
            hdd_avalon_master_write = 0;
            hdd_avalon_master_writedata = 0;
            @(posedge clk_sys);
            #2 rst = 0;
            @(posedge clk_sys);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            ao486_rst = 0;
            hdd_avalon_master_address = 32'h0000_0002;
            hdd_avalon_master_read = 1;
            driver_sd_avs_readdata = 32'hDEAD_BEEF;


            @(posedge clk_sys);
            #2;



            #1;




            check_outputs(
                32'h0000_0000,
                1'b1,
                2'h2,
                1'b1,
                1'b0,
                32'h0000_0000,
                32'hDEAD_BEEF,
                1'b1,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            ao486_rst = 0;
            hdd_avalon_master_address = 32'h0000_0003;
            hdd_avalon_master_write = 1;
            hdd_avalon_master_writedata = 32'h1234_5678;

            @(posedge clk_sys);
            #2;

            #1;


            check_outputs(
                32'h0000_0000,
                1'b1,
                2'h3,
                1'b0,
                1'b1,
                32'h1234_5678,
                32'h0000_0000,
                1'b0,
                1'b0
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            ao486_rst = 1;
            bios_loader_address = 32'h0000_0001;
            bios_loader_read = 1;
            driver_sd_avs_readdata = 32'hCAFE_BABE;

            @(posedge clk_sys);
            #2;

            #1;


            check_outputs(
                32'hCAFE_BABE,
                1'b0,
                2'h1,
                1'b1,
                1'b0,
                32'h0000_0000,
                32'h0000_0000,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            ao486_rst = 1;
            bios_loader_address = 32'h0000_0000;
            bios_loader_write = 1;
            bios_loader_writedata = 32'hAAAA_5555;

            @(posedge clk_sys);
            #2;

            #1;


            check_outputs(
                32'h0000_0000,
                1'b0,
                2'h0,
                1'b0,
                1'b1,
                32'hAAAA_5555,
                32'h0000_0000,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            ao486_rst = 1;

            hdd_avalon_master_address = 32'h0000_0003;
            hdd_avalon_master_read = 1;

            bios_loader_address = 32'h0000_0002;
            bios_loader_write = 1;
            bios_loader_writedata = 32'h8888_9999;

            @(posedge clk_sys);
            #2;


            #1;



            check_outputs(
                32'h0000_0000,
                1'b0,
                2'h2,
                1'b0,
                1'b1,
                32'h8888_9999,
                32'h0000_0000,
                1'b0,
                1'b1
            );
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
        input [31:0] expected_bios_loader_readdata;
        input expected_bios_loader_waitrequest;
        input [1:0] expected_driver_sd_avs_address;
        input expected_driver_sd_avs_read;
        input expected_driver_sd_avs_write;
        input [31:0] expected_driver_sd_avs_writedata;
        input [31:0] expected_hdd_avalon_master_readdata;
        input expected_hdd_avalon_master_readdatavalid;
        input expected_hdd_avalon_master_waitrequest;
        begin
            if (expected_bios_loader_readdata === (expected_bios_loader_readdata ^ bios_loader_readdata ^ expected_bios_loader_readdata) &&
                expected_bios_loader_waitrequest === (expected_bios_loader_waitrequest ^ bios_loader_waitrequest ^ expected_bios_loader_waitrequest) &&
                expected_driver_sd_avs_address === (expected_driver_sd_avs_address ^ driver_sd_avs_address ^ expected_driver_sd_avs_address) &&
                expected_driver_sd_avs_read === (expected_driver_sd_avs_read ^ driver_sd_avs_read ^ expected_driver_sd_avs_read) &&
                expected_driver_sd_avs_write === (expected_driver_sd_avs_write ^ driver_sd_avs_write ^ expected_driver_sd_avs_write) &&
                expected_driver_sd_avs_writedata === (expected_driver_sd_avs_writedata ^ driver_sd_avs_writedata ^ expected_driver_sd_avs_writedata) &&
                expected_hdd_avalon_master_readdata === (expected_hdd_avalon_master_readdata ^ hdd_avalon_master_readdata ^ expected_hdd_avalon_master_readdata) &&
                expected_hdd_avalon_master_readdatavalid === (expected_hdd_avalon_master_readdatavalid ^ hdd_avalon_master_readdatavalid ^ expected_hdd_avalon_master_readdatavalid) &&
                expected_hdd_avalon_master_waitrequest === (expected_hdd_avalon_master_waitrequest ^ hdd_avalon_master_waitrequest ^ expected_hdd_avalon_master_waitrequest)) begin
                $display("PASS");
                $display("  Outputs: bios_loader_readdata=%h, bios_loader_waitrequest=%b, driver_sd_avs_address=%h, driver_sd_avs_read=%b, driver_sd_avs_write=%b, driver_sd_avs_writedata=%h, hdd_avalon_master_readdata=%h, hdd_avalon_master_readdatavalid=%b, hdd_avalon_master_waitrequest=%b",
                         bios_loader_readdata, bios_loader_waitrequest, driver_sd_avs_address, driver_sd_avs_read, driver_sd_avs_write, driver_sd_avs_writedata, hdd_avalon_master_readdata, hdd_avalon_master_readdatavalid, hdd_avalon_master_waitrequest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bios_loader_readdata=%h, bios_loader_waitrequest=%b, driver_sd_avs_address=%h, driver_sd_avs_read=%b, driver_sd_avs_write=%b, driver_sd_avs_writedata=%h, hdd_avalon_master_readdata=%h, hdd_avalon_master_readdatavalid=%b, hdd_avalon_master_waitrequest=%b",
                         expected_bios_loader_readdata, expected_bios_loader_waitrequest, expected_driver_sd_avs_address, expected_driver_sd_avs_read, expected_driver_sd_avs_write, expected_driver_sd_avs_writedata, expected_hdd_avalon_master_readdata, expected_hdd_avalon_master_readdatavalid, expected_hdd_avalon_master_waitrequest);
                $display("  Got:      bios_loader_readdata=%h, bios_loader_waitrequest=%b, driver_sd_avs_address=%h, driver_sd_avs_read=%b, driver_sd_avs_write=%b, driver_sd_avs_writedata=%h, hdd_avalon_master_readdata=%h, hdd_avalon_master_readdatavalid=%b, hdd_avalon_master_waitrequest=%b",
                         bios_loader_readdata, bios_loader_waitrequest, driver_sd_avs_address, driver_sd_avs_read, driver_sd_avs_write, driver_sd_avs_writedata, hdd_avalon_master_readdata, hdd_avalon_master_readdatavalid, hdd_avalon_master_waitrequest);
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
        $dumpvars(0,ao486_rst, bios_loader_address, bios_loader_byteenable, bios_loader_read, bios_loader_write, bios_loader_writedata, clk_sys, driver_sd_avs_readdata, hdd_avalon_master_address, hdd_avalon_master_read, hdd_avalon_master_write, hdd_avalon_master_writedata, rst, bios_loader_readdata, bios_loader_waitrequest, driver_sd_avs_address, driver_sd_avs_read, driver_sd_avs_write, driver_sd_avs_writedata, hdd_avalon_master_readdata, hdd_avalon_master_readdatavalid, hdd_avalon_master_waitrequest);
    end

endmodule
