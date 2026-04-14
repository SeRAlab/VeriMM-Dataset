`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mosi;
    reg rst;
    reg sample;
    reg ssel;
    wire miso;
    wire wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mosi(mosi),
        .rst(rst),
        .sample(sample),
        .ssel(ssel),
        .miso(miso),
        .wr(wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            mosi = 0;
            ssel = 0;
            sample = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(1'bx, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Normal sequence to RECEIVE", test_num);
            reset_dut();


            ssel = 1;
            mosi = 1;
            @(posedge clk);


            #2 sample = 1;
            @(posedge clk);


            #1;



            check_outputs(1'bx, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: ssel low (remain IDLE)", test_num);
            reset_dut();

            ssel = 0;
            mosi = 1;
            sample = 1;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(1'bx, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Stay in TRANSMIT (sample low)", test_num);
            reset_dut();


            ssel = 1;
            mosi = 1;
            @(posedge clk);


            #2 sample = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'bx, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Return to IDLE after RECEIVE", test_num);
            reset_dut();


            ssel = 1; mosi = 1;
            @(posedge clk);


            #2 sample = 1;
            @(posedge clk);


            @(posedge clk);

            #1;


            check_outputs(1'bx, 0);
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
        input expected_miso;
        input expected_wr;
        begin
            if (expected_miso === (expected_miso ^ miso ^ expected_miso) &&
                expected_wr === (expected_wr ^ wr ^ expected_wr)) begin
                $display("PASS");
                $display("  Outputs: miso=%b, wr=%b",
                         miso, wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miso=%b, wr=%b",
                         expected_miso, expected_wr);
                $display("  Got:      miso=%b, wr=%b",
                         miso, wr);
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
        $dumpvars(0,clk, mosi, rst, sample, ssel, miso, wr);
    end

endmodule
