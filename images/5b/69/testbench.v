`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] shift_in;
    wire edge_out;
    wire [3:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .shift_in(shift_in),
        .edge_out(edge_out),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            shift_in = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Load data (MSB 0, No Edge)", test_num);
            reset_dut();
            shift_in = 4'b0111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Detect Rising Edge (0 to 1 transition)", test_num);
            reset_dut();

            shift_in = 4'b0101;
            @(posedge clk);
            #1;

            shift_in = 4'b1101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Maintain MSB High (No new edge)", test_num);
            reset_dut();

            shift_in = 4'b1000;
            @(posedge clk);
            #1;

            shift_in = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Falling Edge on MSB (Should not detect)", test_num);
            reset_dut();

            shift_in = 4'b1010;
            @(posedge clk);
            #1;

            shift_in = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Sequential Edge Detections", test_num);
            reset_dut();

            shift_in = 4'b1000; @(posedge clk); #1;

            shift_in = 4'b0000; @(posedge clk); #1;

            shift_in = 4'b1100; @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 4'b1100);
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
        input expected_edge_out;
        input [3:0] expected_shift_out;
        begin
            if (expected_edge_out === (expected_edge_out ^ edge_out ^ expected_edge_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: edge_out=%b, shift_out=%h",
                         edge_out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_out=%b, shift_out=%h",
                         expected_edge_out, expected_shift_out);
                $display("  Got:      edge_out=%b, shift_out=%h",
                         edge_out, shift_out);
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
        $dumpvars(0,clk, reset, shift_in, edge_out, shift_out);
    end

endmodule
