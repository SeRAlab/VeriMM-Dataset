`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLEAR;
    reg CLK;
    reg RSTN;
    reg UP_ENABLE;
    reg UP_ENABLE2;
    wire now;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLEAR(CLEAR),
        .CLK(CLK),
        .RSTN(RSTN),
        .UP_ENABLE(UP_ENABLE),
        .UP_ENABLE2(UP_ENABLE2),
        .now(now)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RSTN = 0;
            CLEAR = 0;
            UP_ENABLE = 0;
            UP_ENABLE2 = 0;
            @(posedge CLK);
            #1;
            RSTN = 1;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset state check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single enable test", test_num);
            reset_dut();
            UP_ENABLE = 1;
            UP_ENABLE2 = 0;
            repeat(10) @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Increment to limit (5)", test_num);
            reset_dut();
            UP_ENABLE = 1;
            UP_ENABLE2 = 1;

            repeat(5) @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Wrap around and secondary cycle", test_num);
            reset_dut();
            UP_ENABLE = 1;
            UP_ENABLE2 = 1;

            repeat(5) @(posedge CLK);

            repeat(6) @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Synchronous CLEAR check", test_num);
            reset_dut();
            UP_ENABLE = 1;
            UP_ENABLE2 = 1;

            repeat(3) @(posedge CLK);
            CLEAR = 1;
            @(posedge CLK);
            CLEAR = 0;
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Intermittent enables", test_num);
            reset_dut();
            UP_ENABLE = 1;
            UP_ENABLE2 = 1;
            repeat(2) @(posedge CLK);
            UP_ENABLE = 0;
            repeat(5) @(posedge CLK);
            UP_ENABLE = 1;
            repeat(3) @(posedge CLK);
            #1;

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
        input expected_now;
        begin
            if (expected_now === (expected_now ^ now ^ expected_now)) begin
                $display("PASS");
                $display("  Outputs: now=%b",
                         now);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: now=%b",
                         expected_now);
                $display("  Got:      now=%b",
                         now);
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
        $dumpvars(0,CLEAR, CLK, RSTN, UP_ENABLE, UP_ENABLE2, now);
    end

endmodule
