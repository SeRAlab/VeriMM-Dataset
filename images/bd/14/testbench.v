`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_in;
    reg clk;
    reg reset;
    wire EN1;
    wire EN2;
    wire EN3;
    wire [3:0] bcd_out;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .clk(clk),
        .reset(reset),
        .EN1(EN1),
        .EN2(EN2),
        .EN3(EN3),
        .bcd_out(bcd_out),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        binary_in = 4'd14;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b0, 4'd4, 9'd4);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        binary_in = 4'd14;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0, 1'b1, 1'b0, 4'd1, 9'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        binary_in = 4'd14;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
        repeat(2) @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 4'd0, 9'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        binary_in = 4'd5;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 4'd5, 9'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        binary_in = 4'd5;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 4'd0, 9'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        binary_in = 4'd15;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 4'd5, 9'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        binary_in = 4'd15;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 4'd1, 9'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        binary_in = 4'd0;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 4'd0, 9'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        binary_in = 4'd10;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 4'd1, 9'd2);
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
        input expected_EN1;
        input expected_EN2;
        input expected_EN3;
        input [3:0] expected_bcd_out;
        input [8:0] expected_sum;
        begin
            if (expected_EN1 === (expected_EN1 ^ EN1 ^ expected_EN1) &&
                expected_EN2 === (expected_EN2 ^ EN2 ^ expected_EN2) &&
                expected_EN3 === (expected_EN3 ^ EN3 ^ expected_EN3) &&
                expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: EN1=%b, EN2=%b, EN3=%b, bcd_out=%h, sum=%h",
                         EN1, EN2, EN3, bcd_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN1=%b, EN2=%b, EN3=%b, bcd_out=%h, sum=%h",
                         expected_EN1, expected_EN2, expected_EN3, expected_bcd_out, expected_sum);
                $display("  Got:      EN1=%b, EN2=%b, EN3=%b, bcd_out=%h, sum=%h",
                         EN1, EN2, EN3, bcd_out, sum);
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
        $dumpvars(0,binary_in, clk, reset, EN1, EN2, EN3, bcd_out, sum);
    end

endmodule
