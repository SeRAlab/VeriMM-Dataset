`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] c;
    reg u;
    wire C2;
    wire C3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .u(u),
        .C2(C2),
        .C3(C3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: From State K (Reset State), u=0 -> Expect Next State L (C2=1, C3=0)", test_num);

            c = 3'b001;
            u = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: From State K (Reset State), u=1 -> Expect Next State M (C2=0, C3=1)", test_num);

            c = 3'b001;
            u = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: From State L, u=0 -> Expect Next State K (C2=0, C3=0)", test_num);

            c = 3'b010;
            u = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: From State L, u=1 -> Expect Next State M (C2=0, C3=1)", test_num);

            c = 3'b010;
            u = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: From State M, u=0 -> Expect Next State L (C2=1, C3=0)", test_num);

            c = 3'b100;
            u = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: From State M, u=1 -> Expect Next State K (C2=0, C3=0)", test_num);

            c = 3'b100;
            u = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Invalid All-Zeros State, u=0 -> Expect Next State All-Zeros (C2=0, C3=0)", test_num);
            c = 3'b000;
            u = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Invalid All-Ones State, u=0 -> Expect Combined Logic (C2=1, C3=0)", test_num);

            c = 3'b111;
            u = 0;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_C2;
        input expected_C3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C2 === (expected_C2 ^ C2 ^ expected_C2) &&
                expected_C3 === (expected_C3 ^ C3 ^ expected_C3)) begin
                $display("PASS");
                $display("  Outputs: C2=%b, C3=%b",
                         C2, C3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C2=%b, C3=%b",
                         expected_C2, expected_C3);
                $display("  Got:      C2=%b, C3=%b",
                         C2, C3);
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
