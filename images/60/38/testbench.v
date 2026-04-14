`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg reset;
    wire empty;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .reset(reset),
        .empty(empty),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            parallel_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Parallel Input 0xAA");
            test_num = test_num + 1;
            reset_dut();

            parallel_in = 8'hAA;
            load = 1;
            @(posedge clk);
            #1 load = 0;



            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Parallel Input 0x55");
            test_num = test_num + 1;
            reset_dut();

            parallel_in = 8'h55;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Parallel Input 0xFF");
            test_num = test_num + 1;
            reset_dut();

            parallel_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Parallel Input 0x00");
            test_num = test_num + 1;
            reset_dut();

            parallel_in = 8'h00;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Reset State Check");
            test_num = test_num + 1;
            reset_dut();


            #1;



            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Back-to-back Transmission");
            test_num = test_num + 1;
            reset_dut();


            parallel_in = 8'h0F;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(10) @(posedge clk);


            parallel_in = 8'hF0;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
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
        input expected_empty;
        input expected_serial_out;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, serial_out=%b",
                         empty, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, serial_out=%b",
                         expected_empty, expected_serial_out);
                $display("  Got:      empty=%b, serial_out=%b",
                         empty, serial_out);
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
        $dumpvars(0,clk, load, parallel_in, reset, empty, serial_out);
    end

endmodule
