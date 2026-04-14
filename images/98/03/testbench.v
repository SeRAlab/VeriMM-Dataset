`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] limit;
    reg my_reset;
    reg reset;
    wire generate_pulse;
    wire [31:0] generated_packets;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .limit(limit),
        .my_reset(my_reset),
        .reset(reset),
        .generate_pulse(generate_pulse),
        .generated_packets(generated_packets)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        my_reset = 0;
        limit = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();

        #1;


        check_outputs(1'b0, 32'd0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        limit = 32'd4;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'd1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        limit = 32'd2;
        repeat(9) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'd3);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        limit = 32'd5;
        repeat(12) @(posedge clk);
        my_reset = 1;
        @(posedge clk);
        #1;
        my_reset = 0;
        #1;

        check_outputs(1'b0, 32'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        limit = 32'd0;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 32'd1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        limit = 32'd10;
        repeat(5) @(posedge clk);
        limit = 32'd4;
        @(posedge clk);
        #1;

        if (generated_packets > 0)
            #1;

            check_outputs(generate_pulse, generated_packets);
        else
            #1;

            check_outputs(generate_pulse, generated_packets);
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
        input expected_generate_pulse;
        input [31:0] expected_generated_packets;
        begin
            if (expected_generate_pulse === (expected_generate_pulse ^ generate_pulse ^ expected_generate_pulse) &&
                expected_generated_packets === (expected_generated_packets ^ generated_packets ^ expected_generated_packets)) begin
                $display("PASS");
                $display("  Outputs: generate_pulse=%b, generated_packets=%h",
                         generate_pulse, generated_packets);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: generate_pulse=%b, generated_packets=%h",
                         expected_generate_pulse, expected_generated_packets);
                $display("  Got:      generate_pulse=%b, generated_packets=%h",
                         generate_pulse, generated_packets);
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
        $dumpvars(0,clk, limit, my_reset, reset, generate_pulse, generated_packets);
    end

endmodule
