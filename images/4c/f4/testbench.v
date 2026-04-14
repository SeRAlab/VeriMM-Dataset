`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_channel;
    reg [7:0] in_data;
    reg in_endofpacket;
    reg in_startofpacket;
    reg in_valid;
    reg out_ready;
    reg reset_n;
    wire in_ready;
    wire [7:0] out_channel;
    wire [7:0] out_data;
    wire out_endofpacket;
    wire out_startofpacket;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_channel(in_channel),
        .in_data(in_data),
        .in_endofpacket(in_endofpacket),
        .in_startofpacket(in_startofpacket),
        .in_valid(in_valid),
        .out_ready(out_ready),
        .reset_n(reset_n),
        .in_ready(in_ready),
        .out_channel(out_channel),
        .out_data(out_data),
        .out_endofpacket(out_endofpacket),
        .out_startofpacket(out_startofpacket),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            in_valid = 0;
            in_data = 0;
            in_channel = 0;
            in_startofpacket = 0;
            in_endofpacket = 0;
            out_ready = 0;
            repeat(2) @(posedge clk);
            #1;
            reset_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(0, 8'h00, 8'h00, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Channel 0 Data Transfer", test_num);
            reset_dut();
            out_ready = 1;
            in_valid = 1;
            in_data = 8'hA5;
            in_channel = 8'h00;
            in_startofpacket = 1;
            in_endofpacket = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(1, 8'h00, 8'hA5, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Channel > 0 Suppression", test_num);
            reset_dut();
            out_ready = 1;
            in_valid = 1;
            in_data = 8'h5A;
            in_channel = 8'h05;
            in_startofpacket = 0;
            in_endofpacket = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(1, 8'h05, 8'h5A, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Input while out_ready is low", test_num);
            reset_dut();
            out_ready = 0;
            in_valid = 1;
            in_data = 8'hFF;
            in_channel = 8'h00;
            @(posedge clk); #1;

            #1;


            check_outputs(0, 8'h00, 8'h00, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: End of Packet Propagation", test_num);
            reset_dut();
            out_ready = 1;
            in_valid = 1;
            in_data = 8'hEE;
            in_channel = 8'h00;
            in_startofpacket = 0;
            in_endofpacket = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(1, 8'h00, 8'hEE, 1, 0, 1);
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
        input expected_in_ready;
        input [7:0] expected_out_channel;
        input [7:0] expected_out_data;
        input expected_out_endofpacket;
        input expected_out_startofpacket;
        input expected_out_valid;
        begin
            if (expected_in_ready === (expected_in_ready ^ in_ready ^ expected_in_ready) &&
                expected_out_channel === (expected_out_channel ^ out_channel ^ expected_out_channel) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_endofpacket === (expected_out_endofpacket ^ out_endofpacket ^ expected_out_endofpacket) &&
                expected_out_startofpacket === (expected_out_startofpacket ^ out_startofpacket ^ expected_out_startofpacket) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: in_ready=%b, out_channel=%h, out_data=%h, out_endofpacket=%b, out_startofpacket=%b, out_valid=%b",
                         in_ready, out_channel, out_data, out_endofpacket, out_startofpacket, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_ready=%b, out_channel=%h, out_data=%h, out_endofpacket=%b, out_startofpacket=%b, out_valid=%b",
                         expected_in_ready, expected_out_channel, expected_out_data, expected_out_endofpacket, expected_out_startofpacket, expected_out_valid);
                $display("  Got:      in_ready=%b, out_channel=%h, out_data=%h, out_endofpacket=%b, out_startofpacket=%b, out_valid=%b",
                         in_ready, out_channel, out_data, out_endofpacket, out_startofpacket, out_valid);
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
        $dumpvars(0,clk, in_channel, in_data, in_endofpacket, in_startofpacket, in_valid, out_ready, reset_n, in_ready, out_channel, out_data, out_endofpacket, out_startofpacket, out_valid);
    end

endmodule
