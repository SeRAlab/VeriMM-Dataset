`timescale 1ns/1ps

module SRT_Divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [15:0] divisor;
    reg rst;
    wire done;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRT_Divider dut (
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
        dividend = 0;
        divisor = 0;
        @(posedge clk);
        #1 rst = 0;

        while(done) @(posedge clk);
    end
        endtask
    task run_test;

        input [15:0] in_dividend;
        input [15:0] in_divisor;
        input [15:0] exp_q;
        input [15:0] exp_r;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: %d / %d", test_num, in_dividend, in_divisor);
            dividend = in_dividend;
            divisor = in_divisor;


            while(!done) @(posedge clk);


            #1;
            #1;

            check_outputs(1'b1, exp_q, exp_r);
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        run_test(16'd100, 16'd7, 16'd14, 16'd2);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        run_test(16'd144, 16'd12, 16'd12, 16'd0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        run_test(16'hFFFF, 16'd1, 16'hFFFF, 16'd0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        run_test(16'd50000, 16'd25000, 16'd2, 16'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        run_test(16'd10, 16'd20, 16'd0, 16'd10);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        run_test(16'd1024, 16'd32, 16'd32, 16'd0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        run_test(16'hFFFF, 16'hFFFF, 16'd1, 16'd0);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        run_test(16'd10007, 16'd13, 16'd769, 16'd10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRT_Divider Testbench");
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
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
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
