`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg M;
    wire O;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .M(M),
        .O(O),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition (M=0), 5 + 3", test_num);
            A = 4'd5;
            B = 4'd3;
            M = 1'b0;

            #1;


            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition (M=0) with carry, 12 + 5", test_num);
            A = 4'd12;
            B = 4'd5;
            M = 1'b0;


            #1;



            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction (M=1), 10 - 4", test_num);
            A = 4'd10;
            B = 4'd4;
            M = 1'b1;

            #1;


            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction (M=1) with borrow, 2 - 5", test_num);
            A = 4'd2;
            B = 4'd5;
            M = 1'b1;


            #1;



            check_outputs(1'b1, 4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition (M=0), 15 + 15", test_num);
            A = 4'd15;
            B = 4'd15;
            M = 1'b0;


            #1;



            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction (M=1), 7 - 7", test_num);
            A = 4'd7;
            B = 4'd7;
            M = 1'b1;

            #1;


            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction (M=1), 0 - 1", test_num);
            A = 4'd0;
            B = 4'd1;
            M = 1'b1;

            #1;


            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition (M=0), 8 + 8", test_num);
            A = 4'd8;
            B = 4'd8;
            M = 1'b0;

            #1;


            check_outputs(1'b1, 4'd0);
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
        input expected_O;
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: O=%b, Y=%h",
                         O, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b, Y=%h",
                         expected_O, expected_Y);
                $display("  Got:      O=%b, Y=%h",
                         O, Y);
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
