`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CIN;
    wire COUT;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .COUT(COUT),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0+0+0)", test_num);
            A = 4'h0; B = 4'h0; CIN = 1'b0;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum inputs with Carry-In (0+0+1)", test_num);
            A = 4'h0; B = 4'h0; CIN = 1'b1;
            #1;

            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (5+3+0)", test_num);
            A = 4'h5; B = 4'h3; CIN = 1'b0;
            #1;

            check_outputs(1'b0, 4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Carry-In (5+3+1)", test_num);
            A = 4'h5; B = 4'h3; CIN = 1'b1;
            #1;

            check_outputs(1'b0, 4'h9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max result without Carry-Out (7+8+0)", test_num);
            A = 4'h7; B = 4'h8; CIN = 1'b0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Carry-Out (15+1+0)", test_num);
            A = 4'hF; B = 4'h1; CIN = 1'b0;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-Out via Carry-In (15+0+1)", test_num);
            A = 4'hF; B = 4'h0; CIN = 1'b1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible value (15+15+1)", test_num);
            A = 4'hF; B = 4'hF; CIN = 1'b1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (10+5+0)", test_num);
            A = 4'hA; B = 4'h5; CIN = 1'b0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range carry (7+1+0)", test_num);
            A = 4'h7; B = 4'h1; CIN = 1'b0;
            #1;

            check_outputs(1'b0, 4'h8);
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
        input expected_COUT;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, S=%h",
                         COUT, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, S=%h",
                         expected_COUT, expected_S);
                $display("  Got:      COUT=%b, S=%h",
                         COUT, S);
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
