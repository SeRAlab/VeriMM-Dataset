`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    reg [3:0] load_value;
    reg reset;
    wire [3:0] counter_out;
    wire [103:0] final_out;
    wire [99:0] rotator_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .counter_out(counter_out),
        .final_out(final_out),
        .rotator_out(rotator_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            ena = 0;
            data = 0;
            load_value = 0;
            #12;
            reset = 0;
            #3;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h8, 104'h8, 100'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h9, 104'h9, 100'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            load = 1;
            load_value = 4'h4;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(4'h4, 104'h4, 100'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 100'h1;
            ena = 2'b10;
            #2;

            #1;


            check_outputs(4'h8, 104'hA, 100'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 100'h1;
            ena = 2'b01;
            #2;



            #1;




            check_outputs(4'h8, 104'h08000000000000000000000008, 100'h8000000000000000000000000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();
            for(i=0; i<8; i=i+1) @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0, 104'h0, 100'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data = 100'hABC;
            ena = 2'b00;
            #2;

            #1;


            check_outputs(4'h8, 104'hAC4, 100'hABC);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data = 100'hABC;
            ena = 2'b11;
            #2;
            #1;

            check_outputs(4'h8, 104'hAC4, 100'hABC);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            load = 1;
            load_value = 4'hF;
            @(posedge clk);
            #2;
            load = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0, 104'h0, 100'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            load = 1;
            load_value = 4'h1;
            data = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            ena = 2'b00;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h1, 104'h01000000000000000000000000, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
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
        input [3:0] expected_counter_out;
        input [103:0] expected_final_out;
        input [99:0] expected_rotator_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_rotator_out === (expected_rotator_out ^ rotator_out ^ expected_rotator_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, final_out=%h, rotator_out=%h",
                         counter_out, final_out, rotator_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, final_out=%h, rotator_out=%h",
                         expected_counter_out, expected_final_out, expected_rotator_out);
                $display("  Got:      counter_out=%h, final_out=%h, rotator_out=%h",
                         counter_out, final_out, rotator_out);
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
        $dumpvars(0,clk, data, ena, load, load_value, reset, counter_out, final_out, rotator_out);
    end

endmodule
