`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg load;
    reg shift_left;
    wire [2:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_left(shift_left),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            data_in = 0;
            shift_left = 0;
            repeat(3) @(posedge clk);
            load = 0;
            shift_left = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load sequence 1-0-1", test_num);
            reset_dut();

            load = 1; data_in = 1; @(posedge clk);

            load = 1; data_in = 0; @(posedge clk);

            load = 1; data_in = 1; @(posedge clk);
            load = 0;
            @(negedge clk);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left once", test_num);
            reset_dut();

            load = 1; data_in = 1; @(posedge clk);
            load = 1; data_in = 0; @(posedge clk);
            load = 1; data_in = 1; @(posedge clk);


            load = 0; shift_left = 1; @(posedge clk);
            shift_left = 0;
            @(negedge clk);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Shift Lefts", test_num);
            reset_dut();

            load = 1; data_in = 0; @(posedge clk);
            load = 1; data_in = 0; @(posedge clk);
            load = 1; data_in = 1; @(posedge clk);

            load = 0; shift_left = 1; @(posedge clk);

            @(posedge clk);
            shift_left = 0;
            @(negedge clk);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Priority Check", test_num);
            reset_dut();

            load = 1; data_in = 1; @(posedge clk);



            load = 1; data_in = 0; shift_left = 1; @(posedge clk);
            load = 0; shift_left = 0;
            @(negedge clk);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold state (no signals)", test_num);
            reset_dut();

            load = 1; data_in = 1; @(posedge clk);
            load = 1; data_in = 1; @(posedge clk);
            load = 1; data_in = 0; @(posedge clk);

            load = 0; shift_left = 0;
            repeat(2) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(3'b011);
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
        input [2:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, shift_left, data_out);
    end

endmodule
