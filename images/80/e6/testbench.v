`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] data_in;
    reg read_flag;
    reg reset;
    reg write_flag;
    wire [7:0] data_out;
    wire empty_flag;
    wire full_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data_in(data_in),
        .read_flag(read_flag),
        .reset(reset),
        .write_flag(write_flag),
        .data_out(data_out),
        .empty_flag(empty_flag),
        .full_flag(full_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            write_flag = 0;
            read_flag = 0;
            data_in = 8'h00;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            write_flag = 1; data_in = 8'hA5;
            @(posedge clock);
            write_flag = 0;
            @(posedge clock);

            read_flag = 1;
            @(posedge clock);
            read_flag = 0;
            @(posedge clock);

            #1;


            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge clock);
            write_flag = 1; data_in = 8'h11; @(posedge clock);
            write_flag = 1; data_in = 8'h22; @(posedge clock);
            write_flag = 1; data_in = 8'h33; @(posedge clock);
            write_flag = 1; data_in = 8'h44; @(posedge clock);
            write_flag = 0;
            @(posedge clock);

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            write_flag = 1; data_in = 8'h01; @(posedge clock);
            data_in = 8'h02; @(posedge clock);
            data_in = 8'h03; @(posedge clock);
            data_in = 8'h04; @(posedge clock);
            write_flag = 0;
            @(posedge clock);

            read_flag = 1; @(posedge clock);
            read_flag = 1; @(posedge clock);
            read_flag = 1; @(posedge clock);
            read_flag = 1; @(posedge clock);
            read_flag = 0;
            @(posedge clock);

            #1;


            check_outputs(8'h04, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            write_flag = 1; data_in = 8'hAA; @(posedge clock);
            data_in = 8'hBB; @(posedge clock);
            data_in = 8'hCC; @(posedge clock);
            write_flag = 0;
            read_flag = 1; repeat(3) @(posedge clock);
            read_flag = 0;

            write_flag = 1; data_in = 8'hDD; @(posedge clock);
            data_in = 8'hEE; @(posedge clock);
            write_flag = 0;
            @(posedge clock);

            read_flag = 1; @(posedge clock);
            read_flag = 0;
            @(posedge clock);

            #1;


            check_outputs(8'hDD, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            write_flag = 1; data_in = 8'h55;
            @(posedge clock);

            write_flag = 1; data_in = 8'h66;
            read_flag = 1;
            @(posedge clock);
            write_flag = 0;
            read_flag = 0;
            @(posedge clock);

            #1;


            check_outputs(8'h55, 1'b0, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_empty_flag;
        input expected_full_flag;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty_flag === (expected_empty_flag ^ empty_flag ^ expected_empty_flag) &&
                expected_full_flag === (expected_full_flag ^ full_flag ^ expected_full_flag)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty_flag=%b, full_flag=%b",
                         data_out, empty_flag, full_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty_flag=%b, full_flag=%b",
                         expected_data_out, expected_empty_flag, expected_full_flag);
                $display("  Got:      data_out=%h, empty_flag=%b, full_flag=%b",
                         data_out, empty_flag, full_flag);
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
        $dumpvars(0,clock, data_in, read_flag, reset, write_flag, data_out, empty_flag, full_flag);
    end

endmodule
