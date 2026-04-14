`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CHANNEL_UP;
    reg USER_CLK;
    wire DO_CC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CHANNEL_UP(CHANNEL_UP),
        .USER_CLK(USER_CLK),
        .DO_CC(DO_CC)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

        begin
            CHANNEL_UP = 0;
            repeat(2) @(posedge USER_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset State (CHANNEL_UP=0)", test_num);
            CHANNEL_UP = 0;
            repeat(5) @(posedge USER_CLK);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify DO_CC transition after CHANNEL_UP high", test_num);
            reset_dut();
            CHANNEL_UP = 1;

            repeat(5) @(posedge USER_CLK);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify DO_CC reset on CHANNEL_UP loss", test_num);
            reset_dut();
            CHANNEL_UP = 1;
            repeat(3) @(posedge USER_CLK);

            CHANNEL_UP = 0;
            repeat(2) @(posedge USER_CLK);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Re-activation after second reset", test_num);
            reset_dut();
            CHANNEL_UP = 1;
            repeat(2) @(posedge USER_CLK);
            CHANNEL_UP = 0;
            repeat(2) @(posedge USER_CLK);
            CHANNEL_UP = 1;
            repeat(5) @(posedge USER_CLK);
            #1;

            check_outputs(1'b1);
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
        input expected_DO_CC;
        begin
            if (expected_DO_CC === (expected_DO_CC ^ DO_CC ^ expected_DO_CC)) begin
                $display("PASS");
                $display("  Outputs: DO_CC=%b",
                         DO_CC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO_CC=%b",
                         expected_DO_CC);
                $display("  Got:      DO_CC=%b",
                         DO_CC);
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
        $dumpvars(0,CHANNEL_UP, USER_CLK, DO_CC);
    end

endmodule
