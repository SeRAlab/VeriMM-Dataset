`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_0r0;
    reg i_0r1;
    reg o_0a;
    reg o_1a;
    reg reset;
    wire i_0a;
    wire o_0r;
    wire o_1r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_0r0(i_0r0),
        .i_0r1(i_0r1),
        .o_0a(o_0a),
        .o_1a(o_1a),
        .reset(reset),
        .i_0a(i_0a),
        .o_0r(o_0r),
        .o_1r(o_1r)
    );
    task testcase001;

    begin
        test_num = 1;
        reset = 1;
        i_0r0 = 0; i_0r1 = 0; o_0a = 0; o_1a = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset = 1; #5; reset = 0;
        i_0r0 = 1; i_0r1 = 0; o_0a = 0; o_1a = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset = 1; #5; reset = 0;
        i_0r0 = 0; i_0r1 = 1; o_0a = 0; o_1a = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset = 1; #5; reset = 0;
        i_0r0 = 1; i_0r1 = 1; o_0a = 0; o_1a = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset = 1; #5; reset = 0;
        i_0r0 = 1; i_0r1 = 0; o_0a = 1; o_1a = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset = 1; #5; reset = 0;
        i_0r0 = 0; i_0r1 = 1; o_0a = 0; o_1a = 1;
        #10;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset = 1; #5; reset = 0;
        i_0r0 = 1; i_0r1 = 1; o_0a = 1; o_1a = 1;
        #10;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset = 1; #5; reset = 0;
        i_0r0 = 1; i_0r1 = 1; o_0a = 0; o_1a = 1;
        #10;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset = 0; i_0r0 = 1; i_0r1 = 1; o_0a = 1; o_1a = 1;
        #5;
        reset = 1;
        #10;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset = 1; #5; reset = 0;
        i_0r0 = 0; i_0r1 = 0; o_0a = 1; o_1a = 1;
        #10;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_i_0a;
        input expected_o_0r;
        input expected_o_1r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i_0a === (expected_i_0a ^ i_0a ^ expected_i_0a) &&
                expected_o_0r === (expected_o_0r ^ o_0r ^ expected_o_0r) &&
                expected_o_1r === (expected_o_1r ^ o_1r ^ expected_o_1r)) begin
                $display("PASS");
                $display("  Outputs: i_0a=%b, o_0r=%b, o_1r=%b",
                         i_0a, o_0r, o_1r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_0a=%b, o_0r=%b, o_1r=%b",
                         expected_i_0a, expected_o_0r, expected_o_1r);
                $display("  Got:      i_0a=%b, o_0r=%b, o_1r=%b",
                         i_0a, o_0r, o_1r);
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
