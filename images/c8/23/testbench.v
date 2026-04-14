`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All zeros");
        a = 8'd0; b = 8'd0; c = 8'd0; d = 8'd0;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Simple small addition");
        a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40;
        #1;

        check_outputs(9'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Sum reaching 255 (boundary of 8-bit)");
        a = 8'd100; b = 8'd50; c = 8'd50; d = 8'd55;
        #1;

        check_outputs(9'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Sum reaching 256 (MSB/Carry bit set)");
        a = 8'd128; b = 8'd128; c = 8'd0; d = 8'd0;
        #1;

        check_outputs(9'd256);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: High values sum");
        a = 8'd200; b = 8'd100; d = 8'd50; c = 8'd50;
        #1;

        check_outputs(9'd400);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Max 9-bit sum (511)");
        a = 8'd255; b = 8'd255; c = 8'd1; d = 8'd0;
        #1;

        check_outputs(9'd511);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Maximum possible inputs (Overflow 9-bit)");

        a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd255;
        #1;

        check_outputs(9'd508);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Sum exactly 512 (Wraps to 0 in 9-bit)");
        a = 8'd128; b = 8'd128; c = 8'd128; d = 8'd128;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Alternating bit patterns");
        a = 8'hAA; b = 8'h55; c = 8'hAA; d = 8'h55;

        #1;


        check_outputs(9'd510);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: One max input, others zero");
        a = 8'd255; b = 8'd0; c = 8'd0; d = 8'd0;
        #1;

        check_outputs(9'd255);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [8:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
