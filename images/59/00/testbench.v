`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    wire [1:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .X(X)
    );
    task testcase001;

    begin
        A4 = 0; A3 = 0; A2 = 0; A1 = 0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        A4 = 0; A3 = 0; A2 = 0; A1 = 1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        A4 = 0; A3 = 0; A2 = 1; A1 = 0;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        A4 = 0; A3 = 0; A2 = 1; A1 = 1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        A4 = 0; A3 = 1; A2 = 0; A1 = 0;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        A4 = 0; A3 = 1; A2 = 1; A1 = 1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        A4 = 1; A3 = 0; A2 = 0; A1 = 0;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        A4 = 1; A3 = 1; A2 = 1; A1 = 1;
        #1;

        check_outputs(2'b11);
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
        input [1:0] expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
