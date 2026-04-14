`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire [3:0] C;
    wire Cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .C(C),
        .Cout(Cout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros", test_num);
            A = 4'h0;
            B = 4'h0;
            Cin = 1'b0;
            #1;

            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple addition without carry", test_num);
            A = 4'h3;
            B = 4'h4;
            Cin = 1'b0;
            #1;

            check_outputs(4'h7, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Cin", test_num);
            A = 4'h2;
            B = 4'h2;
            Cin = 1'b1;
            #1;

            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sum exactly 15 (Max without Cout)", test_num);
            A = 4'h7;
            B = 4'h8;
            Cin = 1'b0;
            #1;

            check_outputs(4'hF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sum exactly 16 (Cout set, C is 0)", test_num);
            A = 4'h8;
            B = 4'h8;
            Cin = 1'b0;
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum possible sum (15+15+1 = 31)", test_num);
            A = 4'hF;
            B = 4'hF;
            Cin = 1'b1;
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition overflow with A=10, B=7", test_num);
            A = 4'hA;
            B = 4'h7;
            Cin = 1'b0;
            #1;

            check_outputs(4'h1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Cin contributing to overflow", test_num);
            A = 4'hF;
            B = 4'h0;
            Cin = 1'b1;
            #1;

            check_outputs(4'h0, 1'b1);
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
        input [3:0] expected_C;
        input expected_Cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_Cout === (expected_Cout ^ Cout ^ expected_Cout)) begin
                $display("PASS");
                $display("  Outputs: C=%h, Cout=%b",
                         C, Cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, Cout=%b",
                         expected_C, expected_Cout);
                $display("  Got:      C=%h, Cout=%b",
                         C, Cout);
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
