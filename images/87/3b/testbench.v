`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [4:0] io_in_bits_id;
    reg [1:0] io_in_bits_resp;
    reg io_in_bits_user;
    reg io_in_valid;
    reg io_out_ready;
    reg reset;
    wire io_in_ready;
    wire [4:0] io_out_bits_id;
    wire [1:0] io_out_bits_resp;
    wire io_out_bits_user;
    wire io_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_in_bits_id(io_in_bits_id),
        .io_in_bits_resp(io_in_bits_resp),
        .io_in_bits_user(io_in_bits_user),
        .io_in_valid(io_in_valid),
        .io_out_ready(io_out_ready),
        .reset(reset),
        .io_in_ready(io_in_ready),
        .io_out_bits_id(io_out_bits_id),
        .io_out_bits_resp(io_out_bits_resp),
        .io_out_bits_user(io_out_bits_user),
        .io_out_valid(io_out_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            reset = 1;
            io_in_valid = 0;
            io_out_ready = 1;
            io_in_bits_id = 5'h0;
            io_in_bits_resp = 2'b0;
            io_in_bits_user = 0;
            repeat(2) @(posedge clock);
            #1 reset = 0;
            @(posedge clock);

            #1;


            check_outputs(1, 5'h00, 2'b00, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset = 1; #1 reset = 0;
            @(posedge clock);
            #1;
            io_in_valid = 1;
            io_in_bits_id = 5'h12;
            io_in_bits_resp = 2'b10;
            io_in_bits_user = 1;
            io_out_ready = 1;
            @(posedge clock);
            #1;
            io_in_valid = 0;
            @(posedge clock);

            #1;


            check_outputs(1, 5'h12, 2'b10, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset = 1; #1 reset = 0;
            @(posedge clock);
            #1;
            io_in_valid = 1;
            io_in_bits_id = 5'h0A;
            io_in_bits_resp = 2'b11;
            io_in_bits_user = 0;
            io_out_ready = 0;
            @(posedge clock);
            @(posedge clock);
            #1;

            #1;


            check_outputs(io_in_ready, 5'h0A, 2'b11, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset = 1; #1 reset = 0;
            @(posedge clock);
            #1;
            io_in_valid = 1;
            io_in_bits_id = 5'h1F;
            io_in_bits_resp = 2'b11;
            io_in_bits_user = 1;
            io_out_ready = 1;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(1, 5'h1F, 2'b11, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset = 1; #1 reset = 0;
            @(posedge clock);
            #1;
            io_in_valid = 0;
            io_in_bits_id = 5'h05;
            io_in_bits_resp = 2'b01;
            io_in_bits_user = 1;
            io_out_ready = 1;
            repeat(2) @(posedge clock);
            #1;

            #1;


            check_outputs(1, io_out_bits_id, io_out_bits_resp, io_out_bits_user, 0);
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
        input expected_io_in_ready;
        input [4:0] expected_io_out_bits_id;
        input [1:0] expected_io_out_bits_resp;
        input expected_io_out_bits_user;
        input expected_io_out_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_in_ready === (expected_io_in_ready ^ io_in_ready ^ expected_io_in_ready) &&
                expected_io_out_bits_id === (expected_io_out_bits_id ^ io_out_bits_id ^ expected_io_out_bits_id) &&
                expected_io_out_bits_resp === (expected_io_out_bits_resp ^ io_out_bits_resp ^ expected_io_out_bits_resp) &&
                expected_io_out_bits_user === (expected_io_out_bits_user ^ io_out_bits_user ^ expected_io_out_bits_user) &&
                expected_io_out_valid === (expected_io_out_valid ^ io_out_valid ^ expected_io_out_valid)) begin
                $display("PASS");
                $display("  Outputs: io_in_ready=%b, io_out_bits_id=%h, io_out_bits_resp=%h, io_out_bits_user=%b, io_out_valid=%b",
                         io_in_ready, io_out_bits_id, io_out_bits_resp, io_out_bits_user, io_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_in_ready=%b, io_out_bits_id=%h, io_out_bits_resp=%h, io_out_bits_user=%b, io_out_valid=%b",
                         expected_io_in_ready, expected_io_out_bits_id, expected_io_out_bits_resp, expected_io_out_bits_user, expected_io_out_valid);
                $display("  Got:      io_in_ready=%b, io_out_bits_id=%h, io_out_bits_resp=%h, io_out_bits_user=%b, io_out_valid=%b",
                         io_in_ready, io_out_bits_id, io_out_bits_resp, io_out_bits_user, io_out_valid);
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
