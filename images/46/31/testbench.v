`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] max;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .max(max)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: A > B (Normal range)", test_num);
            A = 8'd50;
            B = 8'd20;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: B > A (Normal range)", test_num);
            A = 8'd15;
            B = 8'd80;
            #1;

            check_outputs(8'd80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: A == B (Should output 0)", test_num);
            A = 8'd100;
            B = 8'd100;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: A is max (255), B is 0", test_num);
            A = 8'hFF;
            B = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: B is max (255), A is 0", test_num);
            A = 8'h00;
            B = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Both are 0 (Should output 0)", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Both are 255 (Should output 0)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: A is B + 1", test_num);
            A = 8'd128;
            B = 8'd127;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: B is A + 1", test_num);
            A = 8'd200;
            B = 8'd201;
            #1;

            check_outputs(8'd201);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Random values", test_num);
            A = 8'd42;
            B = 8'd13;
            #1;

            check_outputs(8'd42);
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
        input [7:0] expected_max;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max === (expected_max ^ max ^ expected_max)) begin
                $display("PASS");
                $display("  Outputs: max=%h",
                         max);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max=%h",
                         expected_max);
                $display("  Got:      max=%h",
                         max);
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
