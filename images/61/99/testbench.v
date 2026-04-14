`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg clk;
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
        .clk(clk),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            A = 4'h0; B = 4'h0; Cin = 1'b0;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max A + 0", test_num);
            A = 4'hF; B = 4'h0; Cin = 1'b0;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry Out Generation", test_num);
            A = 4'hF; B = 4'h1; Cin = 1'b0;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Sum", test_num);
            A = 4'b0101; B = 4'b1010; Cin = 1'b0;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry In Only", test_num);
            A = 4'h0; B = 4'h0; Cin = 1'b1;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry In with Result 16", test_num);
            A = 4'h7; B = 4'h8; Cin = 1'b1;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Sum (15+15+1)", test_num);
            A = 4'hF; B = 4'hF; Cin = 1'b1;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Internal Carry (3+1)", test_num);
            A = 4'b0011; B = 4'b0001; Cin = 1'b0;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 4'b0100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Addition (8+4)", test_num);
            A = 4'h8; B = 4'h4; Cin = 1'b0;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 4'hC);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Carry (8+8)", test_num);
            A = 4'h8; B = 4'h8; Cin = 1'b0;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b1, 4'h0);
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
