`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg count_down;
    reg count_up;
    reg [3:0] data_in;
    reg load;
    reg reset;
    wire [3:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count_down(count_down),
        .count_up(count_up),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        count_down = 0;
        forever #5 count_down = ~count_down;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            count_up = 0;
            count_down = 0;
            data_in = 4'b0;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 4'hA;
            load = 1;
            #10;
            load = 0;
            #10;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 4'h5;
            load = 1;
            #10;
            load = 0;
            count_up = 1;
            #10;
            count_up = 0;
            #10;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 4'h8;
            load = 1;
            #10;
            load = 0;
            count_down = 1;
            #10;
            count_down = 0;
            #10;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            count_up = 1;
            #30;
            count_up = 0;
            #10;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 4'hF;
            load = 1;
            #10;
            load = 0;
            count_down = 1;
            #40;
            count_down = 0;
            #10;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data_in = 4'hF;
            load = 1;
            #10;
            load = 0;
            count_up = 1;
            #10;
            count_up = 0;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            count_down = 1;
            #10;
            count_down = 0;
            #10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            data_in = 4'h5;
            load = 1;
            reset = 1;
            #10;
            reset = 0;
            load = 0;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            data_in = 4'hC;
            load = 1;
            count_up = 1;
            #10;
            load = 0;
            count_up = 0;
            #10;
            #1;

            check_outputs(4'hC);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,count_down, count_up, data_in, load, reset, count_out);
    end

endmodule
