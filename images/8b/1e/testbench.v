`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data;
    reg rst;
    reg ym_p1;
    wire sh;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .rst(rst),
        .ym_p1(ym_p1),
        .sh(sh),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        rst = 0;
        forever #5 rst = ~rst;
    end

        task reset_dut;

        begin
            ym_p1 = 0;
            data = 0;

            repeat(5) @(posedge rst);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Zeros (0x0000)", test_num);
            reset_dut();
            data = 16'h0000;
            ym_p1 = 1; @(posedge rst);
            ym_p1 = 0;
            repeat(16) @(posedge rst);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Ones (0xFFFF)", test_num);
            reset_dut();
            data = 16'hFFFF;
            ym_p1 = 1; @(posedge rst);
            ym_p1 = 0;
            repeat(16) @(posedge rst);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating A (0xAAAA)", test_num);
            reset_dut();
            data = 16'hAAAA;
            ym_p1 = 1; @(posedge rst);
            ym_p1 = 0;
            repeat(16) @(posedge rst);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating B (0x5555)", test_num);
            reset_dut();
            data = 16'h5555;
            ym_p1 = 1; @(posedge rst);
            ym_p1 = 0;
            repeat(16) @(posedge rst);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Bit MSB (0x8000)", test_num);
            reset_dut();
            data = 16'h8000;
            ym_p1 = 1; @(posedge rst);
            ym_p1 = 0;
            repeat(16) @(posedge rst);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Bit LSB (0x0001)", test_num);
            reset_dut();
            data = 16'h0001;
            ym_p1 = 1; @(posedge rst);
            ym_p1 = 0;
            repeat(16) @(posedge rst);
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_sh;
        input expected_so;
        begin
            if (expected_sh === (expected_sh ^ sh ^ expected_sh) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: sh=%b, so=%b",
                         sh, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sh=%b, so=%b",
                         expected_sh, expected_so);
                $display("  Got:      sh=%b, so=%b",
                         sh, so);
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
        $dumpvars(0,data, rst, ym_p1, sh, so);
    end

endmodule
