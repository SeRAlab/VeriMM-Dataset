`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg resetn;
    reg stall_in;
    reg start;
    reg valid_in;
    reg [31:0] workgroup_size;
    wire stall_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .resetn(resetn),
        .stall_in(stall_in),
        .start(start),
        .valid_in(valid_in),
        .workgroup_size(workgroup_size),
        .stall_out(stall_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            stall_in = 0;
            start = 0;
            valid_in = 0;
            workgroup_size = 32'h0;
            @(posedge clock);
            #1 resetn = 1;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("testcase001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Basic Valid Propagation");
            test_num = 2;
            reset_dut();
            start = 1;
            valid_in = 1;
            workgroup_size = 32'd10;
            repeat(2) @(posedge clock);

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: Downstream Stall Handling");
            test_num = 3;
            reset_dut();
            start = 1;
            valid_in = 1;
            @(posedge clock);
            stall_in = 1;
            repeat(2) @(posedge clock);

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: No Start Signal");
            test_num = 4;
            reset_dut();
            start = 0;
            valid_in = 1;
            repeat(3) @(posedge clock);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("testcase005: Valid Input Drop");
            test_num = 5;
            reset_dut();
            start = 1;
            valid_in = 1;
            @(posedge clock);
            @(posedge clock);
            valid_in = 0;
            @(posedge clock);

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("testcase006: Workgroup Size Coordination");
            test_num = 6;
            reset_dut();
            workgroup_size = 32'd1;
            start = 1;
            valid_in = 1;
            @(posedge clock);
            @(posedge clock);

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            $display("testcase007: Recovery from Stall");
            test_num = 7;
            reset_dut();
            start = 1;
            valid_in = 1;
            stall_in = 1;
            @(posedge clock);
            stall_in = 0;
            repeat(3) @(posedge clock);
            #1;

            check_outputs(0, 1);
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
        input expected_stall_out;
        input expected_valid_out;
        begin
            if (expected_stall_out === (expected_stall_out ^ stall_out ^ expected_stall_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: stall_out=%b, valid_out=%b",
                         stall_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stall_out=%b, valid_out=%b",
                         expected_stall_out, expected_valid_out);
                $display("  Got:      stall_out=%b, valid_out=%b",
                         stall_out, valid_out);
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
        $dumpvars(0,clock, resetn, stall_in, start, valid_in, workgroup_size, stall_out, valid_out);
    end

endmodule
