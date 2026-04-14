`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg io_in_0_bits;
    reg io_in_0_valid;
    reg io_out_ready;
    reg reset;
    wire io_chosen;
    wire io_in_0_ready;
    wire io_out_bits;
    wire io_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_in_0_bits(io_in_0_bits),
        .io_in_0_valid(io_in_0_valid),
        .io_out_ready(io_out_ready),
        .reset(reset),
        .io_chosen(io_chosen),
        .io_in_0_ready(io_in_0_ready),
        .io_out_bits(io_out_bits),
        .io_out_valid(io_out_valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            reset = 1;
            io_in_0_valid = 0;
            io_in_0_bits = 0;
            io_out_ready = 0;
            repeat(2) @(posedge clock);
            reset = 0;
            @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset = 1;
            repeat(2) @(posedge clock);
            reset = 0;
            io_in_0_valid = 1;
            io_in_0_bits = 1;
            io_out_ready = 1;
            @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset = 1;
            repeat(2) @(posedge clock);
            reset = 0;
            io_in_0_valid = 1;
            io_in_0_bits = 0;
            io_out_ready = 1;
            @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset = 1;
            repeat(2) @(posedge clock);
            reset = 0;
            io_in_0_valid = 1;
            io_in_0_bits = 1;
            io_out_ready = 0;
            @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset = 1;
            repeat(2) @(posedge clock);
            reset = 0;
            io_in_0_valid = 0;
            io_in_0_bits = 1;
            io_out_ready = 1;
            @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset = 1;
            repeat(2) @(posedge clock);
            reset = 0;
            io_in_0_valid = 0;
            io_out_ready = 0;
            @(posedge clock);
            io_in_0_valid = 1;
            io_in_0_bits = 0;
            io_out_ready = 1;
            @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
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
        input expected_io_chosen;
        input expected_io_in_0_ready;
        input expected_io_out_bits;
        input expected_io_out_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_chosen === (expected_io_chosen ^ io_chosen ^ expected_io_chosen) &&
                expected_io_in_0_ready === (expected_io_in_0_ready ^ io_in_0_ready ^ expected_io_in_0_ready) &&
                expected_io_out_bits === (expected_io_out_bits ^ io_out_bits ^ expected_io_out_bits) &&
                expected_io_out_valid === (expected_io_out_valid ^ io_out_valid ^ expected_io_out_valid)) begin
                $display("PASS");
                $display("  Outputs: io_chosen=%b, io_in_0_ready=%b, io_out_bits=%b, io_out_valid=%b",
                         io_chosen, io_in_0_ready, io_out_bits, io_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_chosen=%b, io_in_0_ready=%b, io_out_bits=%b, io_out_valid=%b",
                         expected_io_chosen, expected_io_in_0_ready, expected_io_out_bits, expected_io_out_valid);
                $display("  Got:      io_chosen=%b, io_in_0_ready=%b, io_out_bits=%b, io_out_valid=%b",
                         io_chosen, io_in_0_ready, io_out_bits, io_out_valid);
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

endmodule
