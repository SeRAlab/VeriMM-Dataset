`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    reg [2:0] vec;
    wire [2:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .vec(vec),
        .final_output(final_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            serial_in = 0;
            vec = 3'b000;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Check");
            reset_dut();

            vec = 3'b111;
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Shift 1-1-1, Mask 111");
            reset_dut();
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            vec = 3'b111;
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Shift 1-0-1, Mask 110");
            reset_dut();
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 0;
            @(posedge clk) serial_in = 1;
            vec = 3'b110;
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Shift 1-1-1, Mask 000");
            reset_dut();
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            vec = 3'b000;
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Shift 0-1-1, Mask 011");
            reset_dut();
            @(posedge clk) serial_in = 0;
            @(posedge clk) serial_in = 1;
            @(posedge clk) serial_in = 1;
            vec = 3'b011;
            #1;
            #1;

            check_outputs(3'b011);
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
        input [2:0] expected_final_output;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h",
                         final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h",
                         expected_final_output);
                $display("  Got:      final_output=%h",
                         final_output);
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
        $dumpvars(0,clk, reset, serial_in, vec, final_output);
    end

endmodule
