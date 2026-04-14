`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [3:0] divisor;
    reg reset;
    wire [3:0] quotient;
    wire ready;
    wire [3:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
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
            reset = 1;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 20 / 4", test_num);
            reset_dut();
            dividend = 8'd20;
            divisor = 4'd4;


            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(4'd5, 1'b1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 25 / 7", test_num);
            reset_dut();
            dividend = 8'd25;
            divisor = 4'd7;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(4'd3, 1'b1, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 0 / 9", test_num);
            reset_dut();
            dividend = 8'd0;
            divisor = 4'd9;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(4'd0, 1'b1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 60 / 4", test_num);
            reset_dut();
            dividend = 8'd60;
            divisor = 4'd4;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(4'd15, 1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 5 / 12", test_num);
            reset_dut();
            dividend = 8'd5;
            divisor = 4'd12;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(4'd0, 1'b1, 4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 13 / 13", test_num);
            reset_dut();
            dividend = 8'd13;
            divisor = 4'd13;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(4'd1, 1'b1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 31 / 8", test_num);
            reset_dut();
            dividend = 8'd31;
            divisor = 4'd8;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(4'd3, 1'b1, 4'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 123 / 10", test_num);
            reset_dut();
            dividend = 8'd123;
            divisor = 4'd10;

            wait(ready == 1);
            @(posedge clk);
            #1;

            check_outputs(4'd12, 1'b1, 4'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("restoring_divider Testbench");
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
        input [3:0] expected_quotient;
        input expected_ready;
        input [3:0] expected_remainder;
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
        $dumpvars(0,clk, dividend, divisor, reset, quotient, ready, remainder);
    end

endmodule
