`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg [23:0] rate;
    reg reset;
    reg strobe_in;
    wire [23:0] count;
    wire strobe_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .rate(rate),
        .reset(reset),
        .strobe_in(strobe_in),
        .count(count),
        .strobe_out(strobe_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            strobe_in = 0;
            rate = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("Testcase %03d: Basic operation (Rate=5)", test_num);
            reset_dut();

            rate = 24'd5;
            enable = 1;
            strobe_in = 1;


            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clock);
                #1;
            end


            #1;



            check_outputs(24'd5, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %03d: Enable signal reset", test_num);
            reset_dut();

            rate = 24'd10;
            enable = 1;
            strobe_in = 1;


            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clock);
            end


            #1 enable = 0;
            @(posedge clock);
            #1;


            #1;



            check_outputs(24'd0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Strobe_in gating check", test_num);
            reset_dut();

            rate = 24'd5;
            enable = 1;
            strobe_in = 0;

            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clock);
            end

            #1;

            #1;


            check_outputs(24'd0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Hardware reset priority", test_num);
            reset_dut();

            rate = 24'd20;
            enable = 1;
            strobe_in = 1;

            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clock);
            end


            #1 reset = 1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(24'd0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Rollover after rate reached", test_num);
            reset_dut();

            rate = 24'd3;
            enable = 1;
            strobe_in = 1;


            for (i = 0; i < 3; i = i + 1) begin
                @(posedge clock);
            end



            @(posedge clock);
            #1;

            #1;


            check_outputs(24'd0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: Dynamic rate change", test_num);
            reset_dut();

            rate = 24'd100;
            enable = 1;
            strobe_in = 1;

            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clock);
            end


            #1 rate = 24'd5;
            @(posedge clock);
            #1;


            #1;



            check_outputs(24'd5, 1'b1);
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
        input [23:0] expected_count;
        input expected_strobe_out;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_strobe_out === (expected_strobe_out ^ strobe_out ^ expected_strobe_out)) begin
                $display("PASS");
                $display("  Outputs: count=%h, strobe_out=%b",
                         count, strobe_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, strobe_out=%b",
                         expected_count, expected_strobe_out);
                $display("  Got:      count=%h, strobe_out=%b",
                         count, strobe_out);
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
        $dumpvars(0,clock, enable, rate, reset, strobe_in, count, strobe_out);
    end

endmodule
