`timescale 1ns/1ps

module I2C_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] data_in;
    reg start;
    reg stop;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Controller dut (
        .clock(clock),
        .data_in(data_in),
        .start(start),
        .stop(stop),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            start = 0;
            stop = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            start = 1;
            @(posedge clock);
            #1;
            $display("testcase001: Checking Start Condition (data_out should be 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            data_in = 8'hA5;
            start = 1;
            @(posedge clock);
            #1 start = 0;
            repeat(8) @(posedge clock);
            #1;
            $display("testcase002: Sending 0xA5, checking if LSB is 1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            data_in = 8'h54;
            start = 1;
            @(posedge clock);
            #1 start = 0;
            repeat(8) @(posedge clock);
            #1;
            $display("testcase003: Sending 0x54, checking if LSB is 0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            data_in = 8'h00;
            start = 1;
            @(posedge clock);
            #1 start = 0;
            repeat(8) @(posedge clock);
            #1 stop = 1;
            @(posedge clock);
            #1;
            $display("testcase004: Checking Stop Condition (data_out should be 1)");
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
        $display("I2C_Controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
        $dumpvars(0,clock, data_in, start, stop, data_out);
    end

endmodule
