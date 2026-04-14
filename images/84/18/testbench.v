`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] D0;
    reg [25:0] D1;
    reg ctrl;
    wire [25:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .ctrl(ctrl),
        .S(S)
    );
    task testcase001;

        begin
            $display("Testcase 001: ctrl=0, D0=0, D1=0");
            test_num = 1;
            ctrl = 1'b0;
            D0 = 26'h0;
            D1 = 26'h0;
            #1;

            check_outputs(26'h0000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: ctrl=1, D0=0, D1=0");
            test_num = 2;
            ctrl = 1'b1;
            D0 = 26'h0;
            D1 = 26'h0;
            #1;

            check_outputs(26'h0000004);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: ctrl=0, D0=All 1s, D1=All 1s");
            test_num = 3;
            ctrl = 1'b0;
            D0 = 26'h3FFFFFF;
            D1 = 26'h3FFFFFF;
            #1;

            check_outputs(26'h0000000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: ctrl=1, D0=All 1s, D1=All 1s");
            test_num = 4;
            ctrl = 1'b1;
            D0 = 26'h3FFFFFF;
            D1 = 26'h3FFFFFF;
            #1;

            check_outputs(26'h0000004);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: ctrl=0, D0=Pattern A, D1=Pattern B");
            test_num = 5;
            ctrl = 1'b0;
            D0 = 26'h1555555;
            D1 = 26'h2AAAAAA;
            #1;

            check_outputs(26'h0000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: ctrl=1, D0=Pattern B, D1=Pattern A");
            test_num = 6;
            ctrl = 1'b1;
            D0 = 26'h2AAAAAA;
            D1 = 26'h1555555;
            #1;

            check_outputs(26'h0000004);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Toggle ctrl check");
            test_num = 7;
            D0 = 26'h3ABCDEF;
            D1 = 26'h0123456;

            ctrl = 1'b1; #1;
            ctrl = 1'b0; #1;
            ctrl = 1'b1;
            #1;

            check_outputs(26'h0000004);
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
        input [25:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
