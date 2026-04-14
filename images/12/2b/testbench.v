`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg start;
    wire [7:0] quotient;
    wire ready;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .start(start),
        .quotient(quotient),
        .ready(ready),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: 20 / 4", test_num);
            dividend = 8'd20;
            divisor = 8'd4;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd5, 1'b1, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: 100 / 3", test_num);
            dividend = 8'd100;
            divisor = 8'd3;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd33, 1'b1, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: 5 / 12", test_num);
            dividend = 8'd5;
            divisor = 8'd12;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b1, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: 255 / 1", test_num);
            dividend = 8'd255;
            divisor = 8'd1;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd255, 1'b1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: 0 / 50", test_num);
            dividend = 8'd0;
            divisor = 8'd50;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: 255 / 255", test_num);
            dividend = 8'd255;
            divisor = 8'd255;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd1, 1'b1, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %03d: 17 / 4", test_num);
            dividend = 8'd17;
            divisor = 8'd4;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd4, 1'b1, 8'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Testcase %03d: 254 / 2", test_num);
            dividend = 8'd254;
            divisor = 8'd2;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd127, 1'b1, 8'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            $display("Testcase %03d: 130 / 10", test_num);
            dividend = 8'd130;
            divisor = 8'd10;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd13, 1'b1, 8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            $display("Testcase %03d: 200 / 13", test_num);
            dividend = 8'd200;
            divisor = 8'd13;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(ready);
            @(posedge clk);
            #1 #1;
 check_outputs(8'd15, 1'b1, 8'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("non_restoring_divider Testbench");
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
        input [7:0] expected_quotient;
        input expected_ready;
        input [7:0] expected_remainder;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, ready=%b, remainder=%h",
                         quotient, ready, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, ready=%b, remainder=%h",
                         expected_quotient, expected_ready, expected_remainder);
                $display("  Got:      quotient=%h, ready=%b, remainder=%h",
                         quotient, ready, remainder);
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
        $dumpvars(0,clk, dividend, divisor, start, quotient, ready, remainder);
    end

endmodule
