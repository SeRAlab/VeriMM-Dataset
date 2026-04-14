`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire CO;
    wire [3:0] O;
    wire OV;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .CO(CO),
        .O(O),
        .OV(OV)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (2 + 3 = 5)", test_num);
            A = 4'd2; B = 4'd3; C = 4'd0;
            #1;

            check_outputs(1'b0, 4'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Carry (12 + 4 = 0 mod 16)", test_num);
            A = 4'd12; B = 4'd4; C = 4'd0;
            #1;

            check_outputs(1'b1, 4'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Overflow (7 + 1 = 8 signed/-8 unsigned)", test_num);
            A = 4'b0111; B = 4'b0001; C = 4'd0;
            #1;

            check_outputs(1'b0, 4'b1000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Overflow (-8 + -1 = -9 signed)", test_num);
            A = 4'b1000; B = 4'b1111; C = 4'd0;
            #1;

            check_outputs(1'b1, 4'b0111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Subtraction (5 - 2 = 3)", test_num);
            A = 4'd5; B = 4'd2; C = 4'd1;

            #1;


            check_outputs(1'b1, 4'd3, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Negative Result (2 - 5 = -3)", test_num);
            A = 4'd2; B = 4'd5; C = 4'd1;

            #1;


            check_outputs(1'b0, 4'b1101, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Positive Overflow (7 - (-1) = 8)", test_num);
            A = 4'b0111; B = 4'b1111; C = 4'd1;
            #1;

            check_outputs(1'b0, 4'b1000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Negative Overflow (-8 - 1 = -9)", test_num);
            A = 4'b1000; B = 4'b0001; C = 4'd1;
            #1;

            check_outputs(1'b1, 4'b0111, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Zero", test_num);
            A = 4'b1010; B = 4'b0000; C = 4'd0;
            #1;

            check_outputs(1'b0, 4'b1010, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Resulting in Zero (5 - 5)", test_num);
            A = 4'd5; B = 4'd5; C = 4'd1;
            #1;

            check_outputs(1'b1, 4'd0, 1'b0);
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
        input expected_CO;
        input [3:0] expected_O;
        input expected_OV;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_O === (expected_O ^ O ^ expected_O) &&
                expected_OV === (expected_OV ^ OV ^ expected_OV)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, O=%h, OV=%b",
                         CO, O, OV);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, O=%h, OV=%b",
                         expected_CO, expected_O, expected_OV);
                $display("  Got:      CO=%b, O=%h, OV=%b",
                         CO, O, OV);
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
