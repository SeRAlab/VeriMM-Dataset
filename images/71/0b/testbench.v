`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg setA;
    reg setB;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .setA(setA),
        .setB(setB),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            setA = 0;
            setB = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: SetA = 1, SetB = 0 (Expect y = 0)");
            reset_dut();
            test_num = 1;
            setA = 1;
            setB = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: SetA = 0, SetB = 1 (Expect y = 1)");
            reset_dut();
            test_num = 2;
            setA = 0;
            setB = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Hold state 1 (Expect y = 1)");
            reset_dut();
            test_num = 3;

            setA = 0;
            setB = 1;
            @(posedge clk);

            #1;
            setA = 0;
            setB = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Hold state 0 (Expect y = 0)");
            reset_dut();
            test_num = 4;

            setA = 1;
            setB = 0;
            @(posedge clk);

            #1;
            setA = 0;
            setB = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: SetA = 1, SetB = 1 (Checking priority)");
            reset_dut();
            test_num = 5;
            setA = 1;
            setB = 1;
            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Transition 0 -> 1");
            reset_dut();
            test_num = 6;

            setA = 1;
            setB = 0;
            @(posedge clk);
            #1;

            setA = 0;
            setB = 1;
            @(posedge clk);
            #2;
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
        input expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
        $dumpvars(0,clk, setA, setB, y);
    end

endmodule
