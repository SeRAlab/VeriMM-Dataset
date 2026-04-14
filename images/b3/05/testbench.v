`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] delay;
    reg enable;
    reg reset_n;
    reg start;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .delay(delay),
        .enable(enable),
        .reset_n(reset_n),
        .start(start),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            start = 0;
            enable = 0;
            delay = 8'h00;
            @(posedge clk);
            #2;
            reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Delay (delay=5)", test_num);
            reset_dut();
            delay = 8'd5;
            enable = 1;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;



            repeat (2000) begin
                if (done) break;
                @(posedge clk);
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Delay with Enable Pausing", test_num);
            reset_dut();
            delay = 8'd3;
            enable = 1;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (10) @(posedge clk);
            enable = 0;
            repeat (50) @(posedge clk);
            enable = 1;


            repeat (2000) begin
                if (done) break;
                @(posedge clk);
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();
            delay = 8'd10;
            enable = 1;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (20) @(posedge clk);
            reset_n = 0;
            @(posedge clk);
            reset_n = 1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum Delay (delay=1)", test_num);
            reset_dut();
            delay = 8'd1;
            enable = 1;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (500) begin
                if (done) break;
                @(posedge clk);
            end
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple starts", test_num);
            reset_dut();
            delay = 8'd2;
            enable = 1;


            @(posedge clk);
            start = 1; @(posedge clk); start = 0;
            repeat (1000) if (done) break; @(posedge clk);


            @(posedge clk);
            start = 1; @(posedge clk); start = 0;
            repeat (1000) if (done) break; @(posedge clk);

            #1;


            check_outputs(1'b1);
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
        begin
            if (expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: done=%b",
                         done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b",
                         expected_done);
                $display("  Got:      done=%b",
                         done);
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
        $dumpvars(0,clk, delay, enable, reset_n, start, done);
    end

endmodule
