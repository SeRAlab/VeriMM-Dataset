`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg b;
    reg [3:0] t;
    wire T2;
    wire T4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .t(t),
        .T2(T2),
        .T4(T4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: From P (0001), b=0 -> Expect T2=1, T4=0", test_num);
            t = 4'b0001;
            b = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: From P (0001), b=1 -> Expect T2=0, T4=0", test_num);
            t = 4'b0001;
            b = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: From Q (0010), b=0 -> Expect T2=0, T4=0", test_num);
            t = 4'b0010;
            b = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: From Q (0010), b=1 -> Expect T2=0, T4=1", test_num);
            t = 4'b0010;
            b = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: From R (0100), b=0 -> Expect T2=1, T4=0", test_num);
            t = 4'b0100;
            b = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: From R (0100), b=1 -> Expect T2=0, T4=0", test_num);
            t = 4'b0100;
            b = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: From S (1000), b=0 -> Expect T2=0, T4=1", test_num);
            t = 4'b1000;
            b = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: From S (1000), b=1 -> Expect T2=0, T4=0", test_num);
            t = 4'b1000;
            b = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: No-hot (0000), b=0 -> Expect T2=0, T4=0", test_num);
            t = 4'b0000;
            b = 0;
            #1;

            check_outputs(1'b0, 1'b0);
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
        testcase009();
        
        
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
        input expected_T2;
        input expected_T4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_T2 === (expected_T2 ^ T2 ^ expected_T2) &&
                expected_T4 === (expected_T4 ^ T4 ^ expected_T4)) begin
                $display("PASS");
                $display("  Outputs: T2=%b, T4=%b",
                         T2, T4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: T2=%b, T4=%b",
                         expected_T2, expected_T4);
                $display("  Got:      T2=%b, T4=%b",
                         T2, T4);
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
