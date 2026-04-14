`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg [3:0] data_in;
    reg enable;
    reg loadn;
    wire [3:0] data_out;
    wire tc;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .data_in(data_in),
        .enable(enable),
        .loadn(loadn),
        .data_out(data_out),
        .tc(tc),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

        begin
            clear = 1;
            enable = 0;
            loadn = 1;
            data_in = 4'd0;
            #12;
            clear = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clock);
            data_in = 4'd9;
            loadn = 0;
            @(negedge clock);
            loadn = 1;

            #1;


            check_outputs(4'd9, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clock);
            data_in = 4'd5;
            loadn = 0;
            @(negedge clock);
            loadn = 1; enable = 1;
            @(negedge clock);
            #1;

            check_outputs(4'd4, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clock);
            data_in = 4'd1;
            loadn = 0;
            @(negedge clock);
            loadn = 1; enable = 1;
            @(negedge clock);

            #1;


            check_outputs(4'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clock);
            data_in = 4'd0;
            loadn = 0;
            @(negedge clock);
            loadn = 1; enable = 1;
            @(negedge clock);

            #1;


            check_outputs(4'd9, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clock);
            data_in = 4'd7;
            loadn = 0;
            @(negedge clock);
            loadn = 1; enable = 0;
            @(negedge clock);

            #1;


            check_outputs(4'd7, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(negedge clock);
            data_in = 4'd3;
            loadn = 0; enable = 1;
            @(negedge clock);

            #1;


            check_outputs(4'd3, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(negedge clock);
            data_in = 4'd0;
            loadn = 0;
            @(negedge clock);
            loadn = 1; enable = 0;
            @(negedge clock);

            #1;


            check_outputs(4'd0, 1'b0, 1'b1);
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
        testcase008();
        
        
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
        input [3:0] expected_data_out;
        input expected_tc;
        input expected_zero;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, tc=%b, zero=%b",
                         data_out, tc, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, tc=%b, zero=%b",
                         expected_data_out, expected_tc, expected_zero);
                $display("  Got:      data_out=%h, tc=%b, zero=%b",
                         data_out, tc, zero);
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
        $dumpvars(0,clear, clock, data_in, enable, loadn, data_out, tc, zero);
    end

endmodule
