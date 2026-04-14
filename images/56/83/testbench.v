`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_write;
    reg [11:0] data_in;
    reg pb_signal;
    wire [11:0] data_out;
    wire [4:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_write(clk_write),
        .data_in(data_in),
        .pb_signal(pb_signal),
        .data_out(data_out),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        clk_write = 0;
        forever #5 clk_write = ~clk_write;
    end

        task reset_dut;

        begin
            pb_signal = 0;
            data_in = 12'h000;

            repeat(5) @(posedge clk_write);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single PB Press - Increment LED", test_num);
            reset_dut();


            @(posedge clk_write);
            pb_signal = 1;
            repeat(2) @(posedge clk_write);
            pb_signal = 0;
            repeat(5) @(posedge clk_write);


            #1;



            check_outputs(12'h000, 5'h01);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Five PB Presses - Wrap Around Check", test_num);
            reset_dut();


            for (i = 0; i < 5; i = i + 1) begin
                pb_signal = 1;
                repeat(2) @(posedge clk_write);
                pb_signal = 0;
                repeat(5) @(posedge clk_write);
            end


            #1;



            check_outputs(12'h000, 5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data Input Flow Check", test_num);
            reset_dut();


            data_in = 12'hABC;
            repeat(10) @(posedge clk_write);


            #1;



            check_outputs(12'h000, 5'h00);
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
        input [11:0] expected_data_out;
        input [4:0] expected_led;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, led=%h",
                         data_out, led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, led=%h",
                         expected_data_out, expected_led);
                $display("  Got:      data_out=%h, led=%h",
                         data_out, led);
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
        $dumpvars(0,clk_write, data_in, pb_signal, data_out, led);
    end

endmodule
