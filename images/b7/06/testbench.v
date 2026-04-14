`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en_sw;
    reg en_tb;
    reg [7:0] pel_sw;
    reg [7:0] pel_tb;
    reg rst_n;
    wire [7:0] ad;
    wire [7:0] nxt_sw;
    wire [7:0] nxt_tb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en_sw(en_sw),
        .en_tb(en_tb),
        .pel_sw(pel_sw),
        .pel_tb(pel_tb),
        .rst_n(rst_n),
        .ad(ad),
        .nxt_sw(nxt_sw),
        .nxt_tb(nxt_tb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en_sw = 0;
            en_tb = 0;
            pel_sw = 0;
            pel_tb = 0;
            #15;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load basic values (sw > tb)", test_num);

            @(posedge clk);
            en_sw = 1;
            en_tb = 1;
            pel_sw = 8'd50;
            pel_tb = 8'd20;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30, 8'd50, 8'd20);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load basic values (tb > sw)", test_num);

            @(posedge clk);
            en_sw = 1;
            en_tb = 1;
            pel_sw = 8'd10;
            pel_tb = 8'd100;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd90, 8'd10, 8'd100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify enable signals (no update when en=0)", test_num);


            @(posedge clk);
            en_sw = 1;
            en_tb = 1;
            pel_sw = 8'hAA;
            pel_tb = 8'h55;

            @(posedge clk);

            en_sw = 0;
            en_tb = 0;
            pel_sw = 8'hFF;
            pel_tb = 8'hFF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55, 8'hAA, 8'h55);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Independent enable updates", test_num);


            @(posedge clk);
            en_sw = 1;
            en_tb = 0;
            pel_sw = 8'd200;
            pel_tb = 8'd50;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd200, 8'd200, 8'd0);


            @(posedge clk);
            en_sw = 0;
            en_tb = 1;
            pel_sw = 8'd10;
            pel_tb = 8'd150;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd50, 8'd200, 8'd150);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values (255 and 0)", test_num);

            @(posedge clk);
            en_sw = 1;
            en_tb = 1;
            pel_sw = 8'd255;
            pel_tb = 8'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255, 8'd255, 8'd0);

            @(posedge clk);
            pel_sw = 8'd128;
            pel_tb = 8'd128;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 8'd128, 8'd128);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous reset behavior", test_num);

            @(posedge clk);
            en_sw = 1;
            en_tb = 1;
            pel_sw = 8'h88;
            pel_tb = 8'h22;

            @(posedge clk);
            #2;
            rst_n = 0;
            #5;

            #1;


            check_outputs(8'd0, 8'd0, 8'd0);
            rst_n = 1;
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
        input [7:0] expected_ad;
        input [7:0] expected_nxt_sw;
        input [7:0] expected_nxt_tb;
        begin
            if (expected_ad === (expected_ad ^ ad ^ expected_ad) &&
                expected_nxt_sw === (expected_nxt_sw ^ nxt_sw ^ expected_nxt_sw) &&
                expected_nxt_tb === (expected_nxt_tb ^ nxt_tb ^ expected_nxt_tb)) begin
                $display("PASS");
                $display("  Outputs: ad=%h, nxt_sw=%h, nxt_tb=%h",
                         ad, nxt_sw, nxt_tb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ad=%h, nxt_sw=%h, nxt_tb=%h",
                         expected_ad, expected_nxt_sw, expected_nxt_tb);
                $display("  Got:      ad=%h, nxt_sw=%h, nxt_tb=%h",
                         ad, nxt_sw, nxt_tb);
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
        $dumpvars(0,clk, en_sw, en_tb, pel_sw, pel_tb, rst_n, ad, nxt_sw, nxt_tb);
    end

endmodule
