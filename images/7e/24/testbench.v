`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] j;
    reg r;
    wire J2;
    wire J3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .j(j),
        .r(r),
        .J2(J2),
        .J3(J3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State D (001), r=0 -> Expect Next State E (J2=1, J3=0)", test_num);

            j = 3'b001;
            r = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State D (001), r=1 -> Expect Next State F (J2=0, J3=1)", test_num);
            j = 3'b001;
            r = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State E (010), r=0 -> Expect Next State D (J2=0, J3=0)", test_num);

            j = 3'b001; r = 1'b0; #1;
            j = 3'b010;
            r = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State E (010), r=1 -> Expect Next State F (J2=0, J3=1)", test_num);
            j = 3'b001; r = 1'b0; #1;
            j = 3'b010;
            r = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: State F (100), r=0 -> Expect Next State E (J2=1, J3=0)", test_num);
            j = 3'b001; r = 1'b0; #1;
            j = 3'b100;
            r = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State F (100), r=1 -> Expect Next State D (J2=0, J3=0)", test_num);
            j = 3'b001; r = 1'b0; #1;
            j = 3'b100;
            r = 1'b1;
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
        input expected_J2;
        input expected_J3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_J2 === (expected_J2 ^ J2 ^ expected_J2) &&
                expected_J3 === (expected_J3 ^ J3 ^ expected_J3)) begin
                $display("PASS");
                $display("  Outputs: J2=%b, J3=%b",
                         J2, J3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: J2=%b, J3=%b",
                         expected_J2, expected_J3);
                $display("  Got:      J2=%b, J3=%b",
                         J2, J3);
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
