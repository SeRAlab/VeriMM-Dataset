`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg parallel_load;
    reg shift_dir;
    wire [7:0] parallel_out;
    wire [7:0] serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .parallel_load(parallel_load),
        .shift_dir(shift_dir),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            parallel_load = 1;
            data_in = 8'h00;
            shift_dir = 0;
            @(posedge clk);
            #1;
            parallel_load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 0xA5", test_num);

            parallel_load = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;
            parallel_load = 0;

            #1;


            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 0x80 -> 0x01", test_num);


            parallel_load = 1;
            data_in = 8'h80;
            @(posedge clk);
            #1;


            parallel_load = 0;
            shift_dir = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 0x01 -> 0x80", test_num);


            parallel_load = 1;
            data_in = 8'h01;
            @(posedge clk);
            #1;


            parallel_load = 0;
            shift_dir = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h80, 8'h80);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 4 times (0x01 -> 0x10)", test_num);

            parallel_load = 1;
            data_in = 8'h01;
            @(posedge clk);
            #1;

            parallel_load = 0;
            shift_dir = 1;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h10, 8'h10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 8 times (Full Rotation 0xAA)", test_num);

            parallel_load = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #1;

            parallel_load = 0;
            shift_dir = 0;
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 0x80 -> 0x40", test_num);

            parallel_load = 1;
            data_in = 8'h80;
            @(posedge clk);
            #1;

            parallel_load = 0;
            shift_dir = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h40, 8'h40);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 0x01 -> 0x02", test_num);

            parallel_load = 1;
            data_in = 8'h01;
            @(posedge clk);
            #1;

            parallel_load = 0;
            shift_dir = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h02, 8'h02);
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
        input [7:0] expected_parallel_out;
        input [7:0] expected_serial_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, serial_out=%h",
                         parallel_out, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, serial_out=%h",
                         expected_parallel_out, expected_serial_out);
                $display("  Got:      parallel_out=%h, serial_out=%h",
                         parallel_out, serial_out);
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
        $dumpvars(0,clk, data_in, parallel_load, shift_dir, parallel_out, serial_out);
    end

endmodule
