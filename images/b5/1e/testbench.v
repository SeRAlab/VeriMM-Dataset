`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire charStatus;
    wire shiftOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .charStatus(charStatus),
        .shiftOut(shiftOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking shiftOut at count 8", test_num);
            reset_dut();
            enable = 1;

            repeat(8) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking charStatus at count 192", test_num);
            reset_dut();
            enable = 1;

            repeat(192) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking reset logic (enable=0)", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking outputs at count 9", test_num);
            reset_dut();
            enable = 1;
            repeat(9) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking outputs at count 193", test_num);
            reset_dut();
            enable = 1;
            repeat(193) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Toggle enable to delay count reaching 8", test_num);
            reset_dut();
            enable = 1;
            repeat(4) @(posedge clk);
            enable = 0;
            @(posedge clk);
            enable = 1;
            repeat(8) @(posedge clk);
            #2;
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
        input expected_charStatus;
        input expected_shiftOut;
        begin
            if (expected_charStatus === (expected_charStatus ^ charStatus ^ expected_charStatus) &&
                expected_shiftOut === (expected_shiftOut ^ shiftOut ^ expected_shiftOut)) begin
                $display("PASS");
                $display("  Outputs: charStatus=%b, shiftOut=%b",
                         charStatus, shiftOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: charStatus=%b, shiftOut=%b",
                         expected_charStatus, expected_shiftOut);
                $display("  Got:      charStatus=%b, shiftOut=%b",
                         charStatus, shiftOut);
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
        $dumpvars(0,clk, enable, charStatus, shiftOut);
    end

endmodule
