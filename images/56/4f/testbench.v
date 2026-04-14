`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] reg_dst;
    reg [2:0] reg_src;
    reg reg_wrt;
    reg [2:0] reg_wrt_dst;
    reg rst;
    reg [7:0] wrt_data;
    wire [7:0] reg_dst_dat;
    wire [7:0] reg_src_dat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reg_dst(reg_dst),
        .reg_src(reg_src),
        .reg_wrt(reg_wrt),
        .reg_wrt_dst(reg_wrt_dst),
        .rst(rst),
        .wrt_data(wrt_data),
        .reg_dst_dat(reg_dst_dat),
        .reg_src_dat(reg_src_dat)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            reg_wrt = 0;
            reg_src = 0;
            reg_dst = 0;
            reg_wrt_dst = 0;
            wrt_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset Values (Reg 3 and Reg 6)", test_num);
            reset_dut();

            reg_src = 3'd3;
            reg_dst = 3'd6;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd6, 8'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write to Register 4 and Read back", test_num);
            reset_dut();


            @(negedge clk);
            reg_wrt = 1;
            reg_wrt_dst = 3'd4;
            wrt_data = 8'hAA;

            @(posedge clk);
            #1 reg_wrt = 0;


            reg_src = 3'd4;
            reg_dst = 3'd0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable (Attempt write when reg_wrt=0)", test_num);
            reset_dut();


            @(negedge clk);
            reg_wrt = 0;
            reg_wrt_dst = 3'd1;
            wrt_data = 8'hFF;

            @(posedge clk);
            #1;


            reg_src = 3'd1;
            reg_dst = 3'd1;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1, 8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Register 7", test_num);
            reset_dut();


            @(negedge clk);
            reg_wrt = 1;
            reg_wrt_dst = 3'd7;
            wrt_data = 8'h55;
            @(posedge clk);


            @(negedge clk);
            wrt_data = 8'h66;
            @(posedge clk);
            #1 reg_wrt = 0;

            reg_src = 3'd7;
            reg_dst = 3'd7;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h66, 8'h66);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Port Read (Reg 2 and Reg 5)", test_num);
            reset_dut();


            @(negedge clk);
            reg_wrt = 1;
            reg_wrt_dst = 3'd2;
            wrt_data = 8'h22;
            @(posedge clk);


            @(negedge clk);
            reg_wrt_dst = 3'd5;
            wrt_data = 8'h55;
            @(posedge clk);
            #1 reg_wrt = 0;


            reg_src = 3'd2;
            reg_dst = 3'd5;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55, 8'h22);
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
        input [7:0] expected_reg_dst_dat;
        input [7:0] expected_reg_src_dat;
        begin
            if (expected_reg_dst_dat === (expected_reg_dst_dat ^ reg_dst_dat ^ expected_reg_dst_dat) &&
                expected_reg_src_dat === (expected_reg_src_dat ^ reg_src_dat ^ expected_reg_src_dat)) begin
                $display("PASS");
                $display("  Outputs: reg_dst_dat=%h, reg_src_dat=%h",
                         reg_dst_dat, reg_src_dat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_dst_dat=%h, reg_src_dat=%h",
                         expected_reg_dst_dat, expected_reg_src_dat);
                $display("  Got:      reg_dst_dat=%h, reg_src_dat=%h",
                         reg_dst_dat, reg_src_dat);
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
        $dumpvars(0,clk, reg_dst, reg_src, reg_wrt, reg_wrt_dst, rst, wrt_data, reg_dst_dat, reg_src_dat);
    end

endmodule
