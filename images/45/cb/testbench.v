`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg load_en;
    reg shift_en;
    wire [3:0] data_out;
    wire empty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .load_en(load_en),
        .shift_en(shift_en),
        .data_out(data_out),
        .empty(empty)
    );

    // Clock generation (10ns period)
    initial begin
        load_en = 0;
        forever #5 load_en = ~load_en;
    end

        task reset_dut;

        begin


            data_in = 4'b0000;
            shift_en = 0;


            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 4'b1011;
            shift_en = 0;
            #20;
            #1;

            check_outputs(4'b1011, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data_in = 4'b0101;
            #10;

            data_in = 4'b0000;
            shift_en = 1;
            #10;
            shift_en = 0;
            #10;

            #1;


            check_outputs(4'b1010, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            data_in = 4'b1000;
            #10;

            shift_en = 1;
            #10;
            shift_en = 0;
            #10;

            #1;


            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            data_in = 4'b0001;
            #10;

            shift_en = 1;
            #30;
            shift_en = 0;
            #10;

            #1;


            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 4'b0000;
            #10;
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 4'b1111;
            #10;
            shift_en = 1;
            #40;
            shift_en = 0;
            #10;
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data_in = 4'b0011;
            #10;
            shift_en = 1;
            #10;
            shift_en = 0;
            data_in = 4'b1100;
            #10;
            #1;

            check_outputs(4'b1100, 1'b0);
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
        input [3:0] expected_data_out;
        input expected_empty;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b",
                         data_out, empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b",
                         expected_data_out, expected_empty);
                $display("  Got:      data_out=%h, empty=%b",
                         data_out, empty);
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
        $dumpvars(0,data_in, load_en, shift_en, data_out, empty);
    end

endmodule
