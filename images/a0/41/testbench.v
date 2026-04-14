`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg rst;
    reg start;
    reg [31:0] value;
    wire done;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .rst(rst),
        .start(start),
        .value(value),
        .done(done),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            start = 0;
            value = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic countdown from 5", test_num);
            reset_dut();

            value = 32'd5;
            load = 1;
            @(posedge clk);
            load = 0;
            #1;

            start = 1;
            @(posedge clk);
            start = 0;


            repeat (10) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Countdown from 15", test_num);
            reset_dut();

            value = 32'd15;
            load = 1;
            @(posedge clk);
            load = 0;
            #1;

            start = 1;
            @(posedge clk);
            start = 0;

            repeat (20) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load without start", test_num);
            reset_dut();

            value = 32'hAAAA_BBBB;
            load = 1;
            @(posedge clk);
            load = 0;


            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b0, 32'hAAAA_BBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset mid-countdown", test_num);
            reset_dut();

            value = 32'd20;
            load = 1;
            @(posedge clk);
            load = 0;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (5) @(posedge clk);

            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Consecutive loads", test_num);
            reset_dut();

            value = 32'd50;
            load = 1;
            @(posedge clk);
            value = 32'd3;
            load = 1;
            @(posedge clk);
            load = 0;

            start = 1;
            @(posedge clk);
            start = 0;

            repeat (6) begin
                if (done) break;
                @(posedge clk);
            end


            #1;



            check_outputs(1'b1, 32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Start with 0 value", test_num);
            reset_dut();

            value = 32'd0;
            load = 1;
            @(posedge clk);
            load = 0;

            start = 1;
            @(posedge clk);
            start = 0;


            repeat (2) begin
                if (done) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1, 32'd0);
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
        input expected_done;
        input [31:0] expected_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out=%h",
                         done, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out=%h",
                         expected_done, expected_out);
                $display("  Got:      done=%b, out=%h",
                         done, out);
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
        $dumpvars(0,clk, load, rst, start, value, done, out);
    end

endmodule
