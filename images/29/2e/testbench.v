`timescale 1ns/1ps

module non_restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] dividend;
    reg [2:0] divisor;
    reg rst;
    wire done;
    wire [4:0] quotient;
    wire [1:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .rst(rst),
        .done(done),
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
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Dividend=10, Divisor=3", test_num);
        dividend = 5'd10;
        divisor = 3'd3;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 5'd3, 2'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Dividend=17, Divisor=4", test_num);
        dividend = 5'd17;
        divisor = 3'd4;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 5'd4, 2'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Dividend=31, Divisor=7", test_num);
        dividend = 5'd31;
        divisor = 3'd7;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 5'd4, 2'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Dividend=5, Divisor=2", test_num);
        dividend = 5'd5;
        divisor = 3'd2;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 5'd2, 2'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Dividend=15, Divisor=5", test_num);
        dividend = 5'd15;
        divisor = 3'd5;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 5'd3, 2'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Dividend=2, Divisor=3", test_num);
        dividend = 5'd2;
        divisor = 3'd3;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 5'd0, 2'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Dividend=25, Divisor=6", test_num);
        dividend = 5'd25;
        divisor = 3'd6;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 5'd4, 2'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Dividend=8, Divisor=2", test_num);
        dividend = 5'd8;
        divisor = 3'd2;
        reset_dut();
        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 5'd4, 2'd0);
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
        input expected_done;
        input [4:0] expected_quotient;
        input [1:0] expected_remainder;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h, remainder=%h",
                         expected_done, expected_quotient, expected_remainder);
                $display("  Got:      done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, rst, done, quotient, remainder);
    end

endmodule
