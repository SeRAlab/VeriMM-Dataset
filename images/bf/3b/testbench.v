`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg [7:0] c;
    wire b;
    wire [31:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .c(c),
        .b(b),
        .d(d)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 1'b0;
        c = 8'd0;
        #1;

        check_outputs(1'b1, 32'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 1'b1;
        c = 8'd255;
        #1;

        check_outputs(1'b0, 32'd265);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 1'b0;
        c = 8'd100;
        #1;

        check_outputs(1'b1, 32'd110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 1'b1;
        c = 8'd246;
        #1;

        check_outputs(1'b0, 32'd256);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 1'b0;
        c = 8'd42;
        #1;

        check_outputs(1'b1, 32'd52);
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
        input expected_b;
        input [31:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: b=%b, d=%h",
                         b, d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%b, d=%h",
                         expected_b, expected_d);
                $display("  Got:      b=%b, d=%h",
                         b, d);
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
