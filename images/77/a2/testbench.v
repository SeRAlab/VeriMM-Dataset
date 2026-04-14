`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c;
    reg [2:0] u;
    wire U2;
    wire U3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .u(u),
        .U2(U2),
        .U3(U3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State M (u=001), Input c=0 -> Expect Next State N (U2=1, U3=0)", test_num);
        u = 3'b001;
        c = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State M (u=001), Input c=1 -> Expect Next State O (U2=0, U3=1)", test_num);
        u = 3'b001;
        c = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State N (u=010), Input c=0 -> Expect Next State M (U2=0, U3=0)", test_num);
        u = 3'b010;
        c = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State N (u=010), Input c=1 -> Expect Next State O (U2=0, U3=1)", test_num);
        u = 3'b010;
        c = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State O (u=100), Input c=0 -> Expect Next State N (U2=1, U3=0)", test_num);
        u = 3'b100;
        c = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: State O (u=100), Input c=1 -> Expect Next State M (U2=0, U3=0)", test_num);
        u = 3'b100;
        c = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Invalid State (u=000), Input c=0 -> Expect All Zero (U2=0, U3=0)", test_num);
        u = 3'b000;
        c = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Invalid State (u=000), Input c=1 -> Expect All Zero (U2=0, U3=0)", test_num);
        u = 3'b000;
        c = 1;
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
        input expected_U2;
        input expected_U3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_U2 === (expected_U2 ^ U2 ^ expected_U2) &&
                expected_U3 === (expected_U3 ^ U3 ^ expected_U3)) begin
                $display("PASS");
                $display("  Outputs: U2=%b, U3=%b",
                         U2, U3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: U2=%b, U3=%b",
                         expected_U2, expected_U3);
                $display("  Got:      U2=%b, U3=%b",
                         U2, U3);
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
