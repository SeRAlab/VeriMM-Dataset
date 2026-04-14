`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg mode;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .mode(mode),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            mode = 1'b0; A = 4'd10; B = 4'd5;
            $display("Test %0d: Mode 0 (A>B), A=10, B=5", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            mode = 1'b0; A = 4'd3; B = 4'd7;
            $display("Test %0d: Mode 0 (A>B), A=3, B=7", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            mode = 1'b0; A = 4'd8; B = 4'd8;
            $display("Test %0d: Mode 0 (A>B), A=8, B=8", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            mode = 1'b0; A = 4'd15; B = 4'd0;
            $display("Test %0d: Mode 0 (A>B), A=15, B=0", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            mode = 1'b1; A = 4'd2; B = 4'd9;
            $display("Test %0d: Mode 1 (A<B), A=2, B=9", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            mode = 1'b1; A = 4'd12; B = 4'd4;
            $display("Test %0d: Mode 1 (A<B), A=12, B=4", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            mode = 1'b1; A = 4'd1; B = 4'd1;
            $display("Test %0d: Mode 1 (A<B), A=1, B=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            mode = 1'b1; A = 4'd0; B = 4'd15;
            $display("Test %0d: Mode 1 (A<B), A=0, B=15", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            mode = 1'b0; A = 4'd0; B = 4'd0;
            $display("Test %0d: Mode 0 (A>B), A=0, B=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            mode = 1'b1; A = 4'd15; B = 4'd15;
            $display("Test %0d: Mode 1 (A<B), A=15, B=15", test_num);
            #1;

            check_outputs(1'b0);
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
        testcase010();
        
        
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
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
                         result);
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
