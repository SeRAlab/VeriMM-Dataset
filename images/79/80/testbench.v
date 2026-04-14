`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pps;
    reg rst;
    wire crtl_pps1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pps(pps),
        .rst(rst),
        .crtl_pps1(crtl_pps1)
    );

    // Clock generation (10ns period)
    initial begin
        pps = 0;
        forever #5 pps = ~pps;
    end

        task reset_dut;

        begin
            rst = 0;
            #15;
            rst = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();
            @(negedge pps);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Toggle (0 -> 1)", test_num);
            reset_dut();
            @(posedge pps);
            @(negedge pps);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Toggle (0 -> 1 -> 0)", test_num);
            reset_dut();
            @(posedge pps);
            @(posedge pps);
            @(negedge pps);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Triple Toggle (0 -> 1 -> 0 -> 1)", test_num);
            reset_dut();
            repeat(3) @(posedge pps);
            @(negedge pps);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Extended Toggling (10 edges)", test_num);
            reset_dut();
            repeat(10) @(posedge pps);
            @(negedge pps);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Override", test_num);
            reset_dut();
            @(posedge pps);
            #2;
            rst = 0;
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_crtl_pps1;
        begin
            if (expected_crtl_pps1 === (expected_crtl_pps1 ^ crtl_pps1 ^ expected_crtl_pps1)) begin
                $display("PASS");
                $display("  Outputs: crtl_pps1=%b",
                         crtl_pps1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crtl_pps1=%b",
                         expected_crtl_pps1);
                $display("  Got:      crtl_pps1=%b",
                         crtl_pps1);
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
        $dumpvars(0,pps, rst, crtl_pps1);
    end

endmodule
