`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: A = 0", test_num);
        A = 4'd0;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: A = 1", test_num);
        A = 4'd1;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: A = 4", test_num);
        A = 4'd4;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: A = 7", test_num);
        A = 4'd7;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: A = 10", test_num);
        A = 4'd10;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: A = 11 (Overflow case)", test_num);
        A = 4'd11;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: A = 13", test_num);
        A = 4'd13;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: A = 15 (Max Input)", test_num);
        A = 4'd15;
        #1;

        check_outputs(4'd4);
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
