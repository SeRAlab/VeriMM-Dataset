`timescale 1ns/1ps

module NonRestoringDivider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] denominator;
    reg [7:0] numerator;
    reg rst;
    reg start;
    wire done;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NonRestoringDivider dut (
        .clk(clk),
        .denominator(denominator),
        .numerator(numerator),
        .rst(rst),
        .start(start),
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
        start = 0;
        numerator = 0;
        denominator = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTest Case %0d: 20 / 4", test_num);
        numerator = 8'd20;
        denominator = 8'd4;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd5, 8'd0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTest Case %0d: 25 / 7", test_num);
        numerator = 8'd25;
        denominator = 8'd7;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd3, 8'd4);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTest Case %0d: 0 / 15", test_num);
        numerator = 8'd0;
        denominator = 8'd15;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd0, 8'd0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTest Case %0d: 50 / 50", test_num);
        numerator = 8'd50;
        denominator = 8'd50;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd1, 8'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTest Case %0d: 5 / 10", test_num);
        numerator = 8'd5;
        denominator = 8'd10;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd0, 8'd5);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTest Case %0d: 255 / 2", test_num);
        numerator = 8'hFF;
        denominator = 8'd2;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd127, 8'd1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTest Case %0d: 100 / 1", test_num);
        numerator = 8'd100;
        denominator = 8'd1;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd100, 8'd0);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("\nTest Case %0d: 255 / 128", test_num);
        numerator = 8'd255;
        denominator = 8'd128;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);
        #1;

        check_outputs(1'b1, 8'd1, 8'd127);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NonRestoringDivider Testbench");
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
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
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
        $dumpvars(0,clk, denominator, numerator, rst, start, done, quotient, remainder);
    end

endmodule
