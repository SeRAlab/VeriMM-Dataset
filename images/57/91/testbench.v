`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg x;
    reg y;
    wire Cout;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cin(Cin),
        .x(x),
        .y(y),
        .Cout(Cout),
        .s(s)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 0; y = 0; Cin = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 0; y = 0; Cin = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 0; y = 1; Cin = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 0; y = 1; Cin = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 1; y = 0; Cin = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 1; y = 0; Cin = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 1; y = 1; Cin = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 1; y = 1; Cin = 1;
            #1;

            check_outputs(1, 1);
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
        testcase007();
        testcase008();
        
        
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
        input expected_Cout;
        input expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, s=%b",
                         Cout, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, s=%b",
                         expected_Cout, expected_s);
                $display("  Got:      Cout=%b, s=%b",
                         Cout, s);
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
