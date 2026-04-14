`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] V;
    wire [3:0] M;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .V(V),
        .M(M),
        .z(z)
    );
    task testcase001;

        integer i;
        reg [4:0] expected;
        begin
            $display("\nRunning testcase001: V[3] is Low");
            for (i = 0; i < 8; i = i + 1) begin
                V = i;
                expected = get_expected(V);
                #1;

                check_outputs(expected[3:0], expected[4]);
            end
        end
        endtask

    task testcase002;

        reg [4:0] expected;
        begin
            $display("\nRunning testcase002: V[3] High, V[2:1] Low");
            V = 4'b1000;
            expected = get_expected(V);
            #1;

            check_outputs(expected[3:0], expected[4]);
            V = 4'b1001;
            expected = get_expected(V);
            #1;

            check_outputs(expected[3:0], expected[4]);
        end
        endtask

    task testcase003;

        reg [4:0] expected;
        begin
            $display("\nRunning testcase003: Condition z=1 (V[3] & V[1])");
            V = 4'b1010;
            expected = get_expected(V);
            #1;

            check_outputs(expected[3:0], expected[4]);
            V = 4'b1011;
            expected = get_expected(V);
            #1;

            check_outputs(expected[3:0], expected[4]);
        end
        endtask

    task testcase004;

        reg [4:0] expected;
        begin
            $display("\nRunning testcase004: Condition z=1 (V[3] & V[2])");
            V = 4'b1100;
            expected = get_expected(V);
            #1;

            check_outputs(expected[3:0], expected[4]);
            V = 4'b1101;
            expected = get_expected(V);
            #1;

            check_outputs(expected[3:0], expected[4]);
        end
        endtask

    task testcase005;

        reg [4:0] expected;
        begin
            $display("\nRunning testcase005: Condition z=1 (Full Match)");
            V = 4'b1110;
            expected = get_expected(V);
            #1;

            check_outputs(expected[3:0], expected[4]);
            V = 4'b1111;
            expected = get_expected(V);
            #1;

            check_outputs(expected[3:0], expected[4]);
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
        input [3:0] expected_M;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M === (expected_M ^ M ^ expected_M) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: M=%h, z=%b",
                         M, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M=%h, z=%b",
                         expected_M, expected_z);
                $display("  Got:      M=%h, z=%b",
                         M, z);
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
