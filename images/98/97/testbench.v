`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire Cout;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0 + 0 + 0)", test_num);
            A = 4'd0; B = 4'd0; Cin = 0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition without carry-out (3 + 4 + 0)", test_num);
            A = 4'd3; B = 4'd4; Cin = 0;
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Carry-in (5 + 2 + 1)", test_num);
            A = 4'd5; B = 4'd2; Cin = 1;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Sum without overflow (7 + 8 + 0)", test_num);
            A = 4'h7; B = 4'h8; Cin = 0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow condition (8 + 8 + 0)", test_num);
            A = 4'h8; B = 4'h8; Cin = 0;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow condition with Cin (15 + 0 + 1)", test_num);
            A = 4'hF; B = 4'h0; Cin = 1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Input values (15 + 15 + 1)", test_num);
            A = 4'hF; B = 4'hF; Cin = 1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ripple carry test (10 + 5 + 0)", test_num);
            A = 4'b1010; B = 4'b0101; Cin = 0;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High bit carry-out (8 + 9 + 0)", test_num);
            A = 4'd8; B = 4'd9; Cin = 0;
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range value (6 + 6 + 1)", test_num);
            A = 4'd6; B = 4'd6; Cin = 1;
            #1;

            check_outputs(1'b0, 4'd13);
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
        input expected_Cout;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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
