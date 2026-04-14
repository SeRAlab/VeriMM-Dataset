`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg parallel_load;
    reg reset;
    reg shift_left_clk;
    reg shift_right_clk;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .parallel_load(parallel_load),
        .reset(reset),
        .shift_left_clk(shift_left_clk),
        .shift_right_clk(shift_right_clk),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        parallel_load = 0;
        forever #5 parallel_load = ~parallel_load;
    end

        task reset_dut;

        begin
            reset = 1;
            shift_left_clk = 0;
            shift_right_clk = 0;
            data_in = 4'b0000;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            data_in = 4'b1010;
            @(posedge parallel_load);
            #2;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            data_in = 4'b1111;
            @(posedge parallel_load);
            #2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            data_in = 4'b1000;
            @(posedge parallel_load);
            #2;

            data_in = 4'b0001;
            shift_left_clk = 1;
            #5;
            shift_left_clk = 0;
            #5;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            data_in = 4'b0011;
            @(posedge parallel_load);
            #2;

            data_in = 4'b0110;
            shift_left_clk = 1;
            #5;
            shift_left_clk = 0;
            #5;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            data_in = 4'b0001;
            @(posedge parallel_load);
            #2;

            data_in = 4'b1000;
            shift_right_clk = 1;
            #5;
            shift_right_clk = 0;
            #5;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;

            data_in = 4'b1100;
            @(posedge parallel_load);
            #2;

            data_in = 4'b0110;
            shift_right_clk = 1;
            #5;
            shift_right_clk = 0;
            #5;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            data_in = 4'b1000;
            @(posedge parallel_load); #2;
            data_in = 4'b0010;

            shift_left_clk = 1; #5; shift_left_clk = 0; #5;

            shift_left_clk = 1; #5; shift_left_clk = 0; #5;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            data_in = 4'b0011;
            @(posedge parallel_load); #2;
            data_in = 4'b1100;

            shift_right_clk = 1; #5; shift_right_clk = 0; #5;

            shift_right_clk = 1; #5; shift_right_clk = 0; #5;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            data_in = 4'b1000;
            @(posedge parallel_load); #2;
            data_in = 4'b1000;
            repeat(4) begin
                shift_left_clk = 1; #5; shift_left_clk = 0; #5;
            end
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            data_in = 4'b1111;
            @(posedge parallel_load); #2;

            shift_left_clk = 1;
            #2;
            reset = 1;
            #5;
            #1;

            check_outputs(4'b0000);
            reset = 0;
            shift_left_clk = 0;
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,data_in, parallel_load, reset, shift_left_clk, shift_right_clk, data_out);
    end

endmodule
