`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg addsub;
    reg [31:0] data_a;
    reg [31:0] data_b;
    reg sign;
    wire [31:0] data_c;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addsub(addsub),
        .data_a(data_a),
        .data_b(data_b),
        .sign(sign),
        .data_c(data_c),
        .overflow(overflow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Addition (No Overflow)", test_num);
            addsub = 1'b0;
            sign = 1'b0;
            data_a = 32'd100;
            data_b = 32'd200;
            #1;

            check_outputs(32'd300, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Addition (Overflow)", test_num);
            addsub = 1'b0;
            sign = 1'b0;
            data_a = 32'hFFFFFFFF;
            data_b = 32'h00000001;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Addition (Pos + Pos, No Overflow)", test_num);
            addsub = 1'b0;
            sign = 1'b1;
            data_a = 32'd1000;
            data_b = 32'd2000;
            #1;

            check_outputs(32'd3000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Addition (Pos + Pos, Overflow)", test_num);
            addsub = 1'b0;
            sign = 1'b1;
            data_a = 32'h7FFFFFFF;
            data_b = 32'h00000001;
            #1;

            check_outputs(32'h80000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Addition (Neg + Neg, Overflow)", test_num);
            addsub = 1'b0;
            sign = 1'b1;
            data_a = 32'h80000000;
            data_b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h7FFFFFFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Subtraction (No Overflow)", test_num);
            addsub = 1'b1;
            sign = 1'b0;
            data_a = 32'd500;
            data_b = 32'd100;
            #1;

            check_outputs(32'd400, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Subtraction (Overflow/Borrow)", test_num);
            addsub = 1'b1;
            sign = 1'b0;
            data_a = 32'd100;
            data_b = 32'd500;
            #1;

            check_outputs(32'hFFFFFE70, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Subtraction (No Overflow)", test_num);
            addsub = 1'b1;
            sign = 1'b1;
            data_a = 32'hFFFFFFFF;
            data_b = 32'h00000001;
            #1;

            check_outputs(32'hFFFFFFFE, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Subtraction (Pos - Neg, Overflow)", test_num);
            addsub = 1'b1;
            sign = 1'b1;
            data_a = 32'h7FFFFFFF;
            data_b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h80000000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Subtraction (Neg - Pos, Overflow)", test_num);
            addsub = 1'b1;
            sign = 1'b1;
            data_a = 32'h80000000;
            data_b = 32'h00000001;
            #1;

            check_outputs(32'h7FFFFFFF, 1'b1);
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
        input [31:0] expected_data_c;
        input expected_overflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_c === (expected_data_c ^ data_c ^ expected_data_c) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: data_c=%h, overflow=%b",
                         data_c, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_c=%h, overflow=%b",
                         expected_data_c, expected_overflow);
                $display("  Got:      data_c=%h, overflow=%b",
                         data_c, overflow);
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
