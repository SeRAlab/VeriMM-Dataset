`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Dec_div;
    reg Load_regs;
    reg clock;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg reset;
    wire [15:0] QR;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Dec_div(Dec_div),
        .Load_regs(Load_regs),
        .clock(clock),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
        .QR(QR),
        .Zero(Zero)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            Dec_div = 0;
            Load_regs = 0;
            dividend = 0;
            divisor = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: 12 / 3 = 4", test_num);
            reset_dut();


            dividend = 8'd12;
            divisor = 8'd3;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;


            Dec_div = 1;
            repeat(4) @(posedge clock);
            #1 Dec_div = 0;

            #1;


            check_outputs(16'd4, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: 0 / 5 = 0", test_num);
            reset_dut();

            dividend = 8'd0;
            divisor = 8'd5;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;


            #1;



            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: 50 / 50 = 1", test_num);
            reset_dut();

            dividend = 8'd50;
            divisor = 8'd50;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;

            Dec_div = 1;
            repeat(1) @(posedge clock);
            #1 Dec_div = 0;

            #1;


            check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: 255 / 5 = 51", test_num);
            reset_dut();

            dividend = 8'd255;
            divisor = 8'd5;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;

            Dec_div = 1;
            repeat(51) @(posedge clock);
            #1 Dec_div = 0;

            #1;


            check_outputs(16'd51, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: 10 / 1 = 10", test_num);
            reset_dut();

            dividend = 8'd10;
            divisor = 8'd1;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;

            Dec_div = 1;
            repeat(10) @(posedge clock);
            #1 Dec_div = 0;

            #1;


            check_outputs(16'd10, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();

            dividend = 8'd20;
            divisor = 8'd2;
            Load_regs = 1;
            @(posedge clock);
            #1 Load_regs = 0;

            Dec_div = 1;
            repeat(5) @(posedge clock);

            #2 reset = 1;
            #5 reset = 0;

            #1;


            check_outputs(16'd0, 1'b1);
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
        input [15:0] expected_QR;
        input expected_Zero;
        begin
            if (expected_QR === (expected_QR ^ QR ^ expected_QR) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: QR=%h, Zero=%b",
                         QR, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QR=%h, Zero=%b",
                         expected_QR, expected_Zero);
                $display("  Got:      QR=%h, Zero=%b",
                         QR, Zero);
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
        $dumpvars(0,Dec_div, Load_regs, clock, dividend, divisor, reset, QR, Zero);
    end

endmodule
