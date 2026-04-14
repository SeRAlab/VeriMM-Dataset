`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [3:0] in4;
    reg [1:0] select;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: Select in1");
            in1 = 4'hA; in2 = 4'h5; in3 = 4'h0; in4 = 4'hF;
            select = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Select in2");
            in1 = 4'hA; in2 = 4'h5; in3 = 4'h0; in4 = 4'hF;
            select = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Select in3");
            in1 = 4'hA; in2 = 4'h5; in3 = 4'h0; in4 = 4'hF;
            select = 2'b10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Select in4");
            in1 = 4'hA; in2 = 4'h5; in3 = 4'h0; in4 = 4'hF;
            select = 2'b11;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: All Inputs 4'hF, Select 01");
            in1 = 4'hF; in2 = 4'hF; in3 = 4'hF; in4 = 4'hF;
            select = 2'b01;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: All Inputs 4'h0, Select 11");
            in1 = 4'h0; in2 = 4'h0; in3 = 4'h0; in4 = 4'h0;
            select = 2'b11;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Change in3 value while select=10");
            in1 = 4'h1; in2 = 4'h2; in3 = 4'h3; in4 = 4'h4;
            select = 2'b10;
            #5;
            in3 = 4'hE;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Rapid select switch");
            in1 = 4'h1; in2 = 4'h2; in3 = 4'h3; in4 = 4'h4;
            select = 2'b00; #2;
            select = 2'b01; #2;
            select = 2'b10; #2;
            select = 2'b11;
            #1;

            check_outputs(4'h4);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
