`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    reg shift_dir;
    wire [3:0] or_out;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift_dir(shift_dir),
        .or_out(or_out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            data_in = 4'h0;
            shift_dir = 0;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left Sequence", test_num);
            reset_dut();
            data_in = 4'hA; shift_dir = 0; @(posedge clk);
            data_in = 4'hB; shift_dir = 0; @(posedge clk);
            data_in = 4'hC; shift_dir = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA | 4'hB, 12'hABC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Right Sequence", test_num);
            reset_dut();
            data_in = 4'h1; shift_dir = 1; @(posedge clk);
            data_in = 4'h2; shift_dir = 1; @(posedge clk);
            data_in = 4'h3; shift_dir = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0 | 4'h1, 12'h321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            reset_dut();

            data_in = 4'hF; shift_dir = 0; @(posedge clk);

            reset = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 12'h000);
            reset = 1;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Left Shift Overflow", test_num);
            reset_dut();
            data_in = 4'h1; shift_dir = 0; @(posedge clk);
            data_in = 4'h2; shift_dir = 0; @(posedge clk);
            data_in = 4'h4; shift_dir = 0; @(posedge clk);
            data_in = 4'h8; shift_dir = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(4'h2 | 4'h4, 12'h248);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Direction Toggling", test_num);
            reset_dut();

            data_in = 4'hF; shift_dir = 0; @(posedge clk);

            data_in = 4'h5; shift_dir = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 12'h500);
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
        input [3:0] expected_or_out;
        input [11:0] expected_q;
        begin
            if (expected_or_out === (expected_or_out ^ or_out ^ expected_or_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: or_out=%h, q=%h",
                         or_out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: or_out=%h, q=%h",
                         expected_or_out, expected_q);
                $display("  Got:      or_out=%h, q=%h",
                         or_out, q);
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
        $dumpvars(0,clk, data_in, reset, shift_dir, or_out, q);
    end

endmodule
