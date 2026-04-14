`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dir;
    reg [3:0] in;
    reg shift;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dir(dir),
        .in(in),
        .shift(shift),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        shift = 0;
        forever #5 shift = ~shift;
    end

        task reset_dut;

        begin


            in = 4'b0000;
            dir = 0;
            repeat(4) @(negedge shift);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left (Serial In: 1-0-1-1)", test_num);
            reset_dut();

            @(negedge shift); dir = 1; in = 4'b0001;
            @(negedge shift); dir = 1; in = 4'b0000;
            @(negedge shift); dir = 1; in = 4'b1111;
            @(negedge shift); dir = 1; in = 4'b0001;

            @(negedge shift);
            #1;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right (Serial In: 1-1-0-1)", test_num);
            reset_dut();

            @(negedge shift); dir = 0; in = 4'b1000;
            @(negedge shift); dir = 0; in = 4'b1111;
            @(negedge shift); dir = 0; in = 4'b0111;
            @(negedge shift); dir = 0; in = 4'b1000;

            @(negedge shift);
            #1;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Direction Shift", test_num);
            reset_dut();


            @(negedge shift); dir = 1; in = 4'b0001;
            @(negedge shift); dir = 1; in = 4'b0001;


            @(negedge shift); dir = 0; in = 4'b0000;
            @(negedge shift); dir = 0; in = 4'b1000;

            @(negedge shift);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill with 1s", test_num);
            reset_dut();

            in = 4'b1001;
            dir = 1;
            repeat(4) @(negedge shift);

            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift out data", test_num);
            reset_dut();


            in = 4'b1001; dir = 1;
            repeat(4) @(negedge shift);


            @(negedge shift); dir = 1; in = 4'b0000;

            #1;
            #1;

            check_outputs(4'b1110);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,dir, in, shift, out);
    end

endmodule
