`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg q;
    reg [3:0] r;
    wire R3;
    wire R4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .q(q),
        .r(r),
        .R3(R3),
        .R4(R4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State E (0001), q=0 -> Next F (R3=0, R4=0)", test_num);
            r = 4'b0001; q = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State E (0001), q=1 -> Next G (R3=1, R4=0)", test_num);
            r = 4'b0001; q = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State F (0010), q=0 -> Next E (R3=0, R4=0)", test_num);
            r = 4'b0010; q = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State F (0010), q=1 -> Next H (R3=0, R4=1)", test_num);
            r = 4'b0010; q = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State G (0100), q=0 -> Next H (R3=0, R4=1)", test_num);
            r = 4'b0100; q = 0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State G (0100), q=1 -> Next E (R3=0, R4=0)", test_num);
            r = 4'b0100; q = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: State H (1000), q=0 -> Next F (R3=0, R4=0)", test_num);
            r = 4'b1000; q = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: State H (1000), q=1 -> Next G (R3=1, R4=0)", test_num);
            r = 4'b1000; q = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Check default (All r=0, q=1) -> R3=0, R4=0", test_num);
            r = 4'b0000; q = 1;
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
        input expected_R3;
        input expected_R4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R3 === (expected_R3 ^ R3 ^ expected_R3) &&
                expected_R4 === (expected_R4 ^ R4 ^ expected_R4)) begin
                $display("PASS");
                $display("  Outputs: R3=%b, R4=%b",
                         R3, R4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R3=%b, R4=%b",
                         expected_R3, expected_R4);
                $display("  Got:      R3=%b, R4=%b",
                         R3, R4);
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
