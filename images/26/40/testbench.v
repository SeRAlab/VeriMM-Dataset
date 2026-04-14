`timescale 1ns/1ps

module divider_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] denominator;
    reg [3:0] numerator;
    reg reset;
    wire [3:0] quotient;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_4bit dut (
        .clk(clk),
        .denominator(denominator),
        .numerator(numerator),
        .reset(reset),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        numerator = 0;
        denominator = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 8 / 2", test_num);
        reset_dut();
        numerator = 4'd8;
        denominator = 4'd2;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'd4, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 7 / 3", test_num);
        reset_dut();
        numerator = 4'd7;
        denominator = 4'd3;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'd2, 4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 3 / 5", test_num);
        reset_dut();
        numerator = 4'd3;
        denominator = 4'd5;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'd0, 4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 13 / 1", test_num);
        reset_dut();
        numerator = 4'd13;
        denominator = 4'd1;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'd13, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 0 / 9", test_num);
        reset_dut();
        numerator = 4'd0;
        denominator = 4'd9;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 15 / 4", test_num);
        reset_dut();
        numerator = 4'd15;
        denominator = 4'd4;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'd3, 4'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 10 / 10", test_num);
        reset_dut();
        numerator = 4'd10;
        denominator = 4'd10;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_4bit Testbench");
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
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, denominator, numerator, reset, quotient, remainder);
    end

endmodule
