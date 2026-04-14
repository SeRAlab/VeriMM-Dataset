`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .O(O)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'h00; B = 8'h00;
            $display("Test Case 001: A=0, B=0");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'h05; B = 8'h0A;
            $display("Test Case 002: A=5, B=10");
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'h0A; B = 8'hFB;
            $display("Test Case 003: A=10, B=-5");
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'h05; B = 8'hF6;
            $display("Test Case 004: A=5, B=-10");
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'h32; B = 8'hCE;
            $display("Test Case 005: A=50, B=-50");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'h7F; B = 8'h01;
            $display("Test Case 006: A=127, B=1 (Signed Overflow)");
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'h80; B = 8'hFF;
            $display("Test Case 007: A=-128, B=-1 (Signed Underflow)");
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'hFE; B = 8'hFE;
            $display("Test Case 008: A=-2, B=-2");
            #1;

            check_outputs(8'hFC);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'h80; B = 8'h7F;
            $display("Test Case 009: A=-128, B=127");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'h80; B = 8'h00;
            $display("Test Case 010: A=-128, B=0");
            #1;

            check_outputs(8'h80);
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
        input [7:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
