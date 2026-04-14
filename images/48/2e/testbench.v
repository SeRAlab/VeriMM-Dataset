`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=0 (Zero Addition)", test_num);
            A = 8'd0;
            B = 8'd0;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=10, B=20 (Simple Addition, No Carry)", test_num);
            A = 8'd10;
            B = 8'd20;

            #1;


            check_outputs(16'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=127, B=128 (Edge of Carry)", test_num);
            A = 8'd127;
            B = 8'd128;

            #1;


            check_outputs(16'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=128, B=128 (Minimum Carry)", test_num);
            A = 8'd128;
            B = 8'd128;


            #1;



            check_outputs(16'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=255, B=1 (Carry Generated)", test_num);
            A = 8'd255;
            B = 8'd1;


            #1;



            check_outputs(16'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=255, B=2 (Carry with Sum Residue)", test_num);
            A = 8'd255;
            B = 8'd2;


            #1;



            check_outputs(16'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=255, B=255 (Maximum Inputs)", test_num);
            A = 8'd255;
            B = 8'd255;


            #1;



            check_outputs(16'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=200, B=100 (Random Carry Case)", test_num);
            A = 8'd200;
            B = 8'd100;


            #1;



            check_outputs(16'd45);
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
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
