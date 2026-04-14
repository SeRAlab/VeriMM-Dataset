`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg rst;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .rst(rst),
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task run_test;

        input [7:0] inp_dividend;
        input [7:0] exp_q;
        input [7:0] exp_r;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Dividend = %d", test_num, inp_dividend);
            reset_dut();
            dividend = inp_dividend;

            repeat (15) @(posedge clk);
            #1;

            check_outputs(exp_q, exp_r);
        end
        endtask

    task testcase001;

        begin
            run_test(8'd6, 8'd2, 8'd0);
        end
        endtask

    task testcase002;

        begin
            run_test(8'd10, 8'd3, 8'd1);
        end
        endtask

    task testcase003;

        begin
            run_test(8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            run_test(8'd255, 8'd85, 8'd0);
        end
        endtask

    task testcase005;

        begin
            run_test(8'd23, 8'd7, 8'd2);
        end
        endtask

    task testcase006;

        begin
            run_test(8'd64, 8'd21, 8'd1);
        end
        endtask

    task testcase007;

        begin
            run_test(8'd1, 8'd0, 8'd1);
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
        input [7:0] expected_remainder;
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
        $dumpvars(0,clk, dividend, rst, quotient, remainder);
    end

endmodule
