`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire c_out;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_out(c_out),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero Addition", test_num);
        a = 8'h00;
        b = 8'h00;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simple Addition (15 + 32)", test_num);
        a = 8'd15;
        b = 8'd32;
        #1;

        check_outputs(1'b0, 8'd47);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Max Sum No Carry (127 + 128)", test_num);
        a = 8'h7F;
        b = 8'h80;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Carry Generation (255 + 1)", test_num);
        a = 8'hFF;
        b = 8'h01;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Carry Generation (128 + 128)", test_num);
        a = 8'h80;
        b = 8'h80;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Max Inputs (255 + 255)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        #1;

        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Bits", test_num);
        a = 8'hAA;
        b = 8'h55;
        #1;

        check_outputs(1'b0, 8'hFF);
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
        input expected_c_out;
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: c_out=%b, y=%h",
                         c_out, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%b, y=%h",
                         expected_c_out, expected_y);
                $display("  Got:      c_out=%b, y=%h",
                         c_out, y);
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
