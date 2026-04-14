`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    wire [31:0] x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .x(x)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial observation", test_num);
            clk = 0;
            #10;


            #1;



            check_outputs(x);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Clock transition to high", test_num);
            clk = 1;
            #10;
            #1;

            check_outputs(x);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Clock transition to low", test_num);
            clk = 0;
            #10;
            #1;

            check_outputs(x);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Long delay observation", test_num);
            #100;
            #1;

            check_outputs(x);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Rapid clock pulsing", test_num);
            repeat(5) begin
                clk = ~clk;
                #5;
            end
            #1;

            check_outputs(x);
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
        input [31:0] expected_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: x=%h",
                         x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h",
                         expected_x);
                $display("  Got:      x=%h",
                         x);
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

endmodule
