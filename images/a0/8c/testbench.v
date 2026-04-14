`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data;
    reg load;
    reg shift;
    wire [3:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .load(load),
        .shift(shift),
        .shifted_data(shifted_data)
    );

    // Clock generation (10ns period)
    initial begin
        load = 0;
        forever #5 load = ~load;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            load = 0;
            shift = 0;
            data = 4'b0000;
            @(negedge clk);
            reset = 0;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Loading data 4'b1010");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 4'b1010;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Shift Left (Circular) 1010 -> 0101");
            reset_dut();

            @(negedge clk);
            load = 1;
            data = 4'b1010;
            @(negedge clk);

            load = 0;
            shift = 1;
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Full rotation (Shift 4 times)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 4'b1000;
            @(negedge clk);
            load = 0;
            shift = 1;
            repeat(4) @(negedge clk);
            shift = 0;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: MSB wrapping (1000 -> 0001)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 4'b1000;
            @(negedge clk);
            load = 0;
            shift = 1;
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Load priority over Shift");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 4'b1111;
            @(negedge clk);

            load = 1;
            shift = 1;
            data = 4'b0110;
            @(negedge clk);
            load = 0;
            shift = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Data persistence (load=0, shift=0)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 4'b0011;
            @(negedge clk);
            load = 0;
            shift = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(4'b0011);
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
        input [3:0] expected_shifted_data;
        begin
            if (expected_shifted_data === (expected_shifted_data ^ shifted_data ^ expected_shifted_data)) begin
                $display("PASS");
                $display("  Outputs: shifted_data=%h",
                         shifted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_data=%h",
                         expected_shifted_data);
                $display("  Got:      shifted_data=%h",
                         shifted_data);
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
        $dumpvars(0,data, load, shift, shifted_data);
    end

endmodule
