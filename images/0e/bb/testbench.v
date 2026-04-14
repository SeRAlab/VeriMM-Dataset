`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] N;
    reg clk;
    reg [15:0] f_in;
    reg rst;
    wire [15:0] f_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .N(N),
        .clk(clk),
        .f_in(f_in),
        .rst(rst),
        .f_out(f_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            f_in = 0;
            N = 0;
            #20;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nRunning Testcase %0d: Basic Integer Division", test_num);
            f_in = 16'd1000;
            N = 16'd10;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nRunning Testcase %0d: Small Divisor", test_num);
            f_in = 16'd500;
            N = 16'd2;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd250);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nRunning Testcase %0d: Unity Division (N=1)", test_num);
            f_in = 16'd750;
            N = 16'd1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd750);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nRunning Testcase %0d: Division by Power of 2", test_num);
            f_in = 16'd1000;
            N = 16'd8;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd125);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nRunning Testcase %0d: Large Input Frequency", test_num);
            f_in = 16'd2000;
            N = 16'd50;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd40);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nRunning Testcase %0d: Higher Frequency Ratio", test_num);
            f_in = 16'd3000;
            N = 16'd3;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_f_out;
        begin
            if (expected_f_out === (expected_f_out ^ f_out ^ expected_f_out)) begin
                $display("PASS");
                $display("  Outputs: f_out=%h",
                         f_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f_out=%h",
                         expected_f_out);
                $display("  Got:      f_out=%h",
                         f_out);
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
        $dumpvars(0,N, clk, f_in, rst, f_out);
    end

endmodule
