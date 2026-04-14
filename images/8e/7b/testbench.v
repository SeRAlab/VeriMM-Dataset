`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg reset;
    reg shift;
    reg up_down;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift(shift),
        .up_down(up_down),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            load = 0;
            shift = 0;
            up_down = 0;
            data_in = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Parallel Load", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 16'hA5A5;
            @(posedge clk);
            load = 0;

            #1;


            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Shift Up Operation", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 16'h0000;
            @(posedge clk);
            load = 0;
            shift = 1;
            up_down = 1;
            repeat(4) @(posedge clk);
            shift = 0;

            #1;


            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Shift Down Operation", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            load = 0;
            shift = 1;
            up_down = 0;
            repeat(3) @(posedge clk);
            shift = 0;
            #1;

            check_outputs(16'hFFFA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Priority (Load over Shift)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            shift = 1;
            data_in = 16'h1234;
            up_down = 1;
            @(posedge clk);
            load = 0;
            shift = 0;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Priority (Reset over All)", test_num);
            reset_dut();
            @(posedge clk);
            reset = 1;
            load = 1;
            shift = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            reset = 0;
            load = 0;
            shift = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Alternating Shift Direction", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 16'h0000;
            @(posedge clk);
            load = 0;
            shift = 1;
            up_down = 1;
            @(posedge clk);
            up_down = 0;
            @(posedge clk);
            shift = 0;


            #1;



            check_outputs(16'h0002);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, reset, shift, up_down, data_out);
    end

endmodule
