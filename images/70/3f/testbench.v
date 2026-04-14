`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] in;
    wire [3:0] lut4_out;
    wire [1:0] lut5_out;
    wire lut6_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .lut4_out(lut4_out),
        .lut5_out(lut5_out),
        .lut6_out(lut6_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All Zeros", test_num);
        in = 6'b000000;

        #1;


        check_outputs(4'h0, 2'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All Ones", test_num);
        in = 6'b111111;

        #1;


        check_outputs(4'h0, 2'h0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Alternating 101010", test_num);
        in = 6'b101010;
        #1;

        check_outputs(4'h0, 2'h0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Alternating 010101", test_num);
        in = 6'b010101;
        #1;

        check_outputs(4'h0, 2'h0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Walking Bit MSB", test_num);
        in = 6'b100000;
        #1;

        check_outputs(4'h0, 2'h0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Walking Bit LSB", test_num);
        in = 6'b000001;
        #1;

        check_outputs(4'h0, 2'h0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Middle Bits", test_num);
        in = 6'b011110;
        #1;

        check_outputs(4'h0, 2'h0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Sparse Pattern", test_num);
        in = 6'b100100;
        #1;

        check_outputs(4'h0, 2'h0, 1'b0);
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
        input [3:0] expected_lut4_out;
        input [1:0] expected_lut5_out;
        input expected_lut6_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lut4_out === (expected_lut4_out ^ lut4_out ^ expected_lut4_out) &&
                expected_lut5_out === (expected_lut5_out ^ lut5_out ^ expected_lut5_out) &&
                expected_lut6_out === (expected_lut6_out ^ lut6_out ^ expected_lut6_out)) begin
                $display("PASS");
                $display("  Outputs: lut4_out=%h, lut5_out=%h, lut6_out=%b",
                         lut4_out, lut5_out, lut6_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lut4_out=%h, lut5_out=%h, lut6_out=%b",
                         expected_lut4_out, expected_lut5_out, expected_lut6_out);
                $display("  Got:      lut4_out=%h, lut5_out=%h, lut6_out=%b",
                         lut4_out, lut5_out, lut6_out);
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
