`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] dividend;
    reg [9:0] divisor;
    reg reset;
    reg start;
    wire done;
    wire [9:0] quotient;
    wire [9:0] remainder;

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
            reset = 1;
            start = 0;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task run_and_check;

        input [9:0] expected_q;
        input [9:0] expected_r;
        begin
            start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);


            #1;
            #1;

            check_outputs(1'b1, expected_q, expected_r);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: 20 / 4", test_num);
            dividend = 10'd20;
            divisor = 10'd4;
            run_and_check(10'd5, 10'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: 20 / 3", test_num);
            dividend = 10'd20;
            divisor = 10'd3;
            run_and_check(10'd6, 10'd2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: 1023 / 1", test_num);
            dividend = 10'd1023;
            divisor = 10'd1;
            run_and_check(10'd1023, 10'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: 512 / 512", test_num);
            dividend = 10'd512;
            divisor = 10'd512;
            run_and_check(10'd1, 10'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: 5 / 12", test_num);
            dividend = 10'd5;
            divisor = 10'd12;
            run_and_check(10'd0, 10'd5);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: 0 / 10", test_num);
            dividend = 10'd0;
            divisor = 10'd10;
            run_and_check(10'd0, 10'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: 1023 / 1023", test_num);
            dividend = 10'd1023;
            divisor = 10'd1023;
            run_and_check(10'd1, 10'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: 1023 / 512", test_num);
            dividend = 10'd1023;
            divisor = 10'd512;
            run_and_check(10'd1, 10'd511);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Test %0d: 511 / 2", test_num);
            dividend = 10'd511;
            divisor = 10'd2;
            run_and_check(10'd255, 10'd1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Test %0d: 777 / 13", test_num);
            dividend = 10'd777;
            divisor = 10'd13;
            run_and_check(10'd59, 10'd10);
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
        input expected_done;
        input [9:0] expected_quotient;
        input [9:0] expected_remainder;
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
        $dumpvars(0,clk, dividend, divisor, reset, start, done, quotient, remainder);
    end

endmodule
