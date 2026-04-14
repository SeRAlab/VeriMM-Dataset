`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg load;
    reg reset;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .load(load),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            load = 0;
            enable = 0;
            data_in = 4'b0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Synchronous Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Synchronous Load Check", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 4'hA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Incremental Count Check (0 to 3)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(negedge clk);
            @(negedge clk);

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Counter Roll-over Check", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 4'hF;
            @(negedge clk);
            load = 0;
            enable = 1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Enable Inhibition Check", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 4'h7;
            @(negedge clk);
            load = 0;
            enable = 0;
            @(negedge clk);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Reset Priority Check", test_num);
            reset_dut();
            @(negedge clk);
            reset = 1;
            load = 1;
            enable = 1;
            data_in = 4'hE;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Load Priority Check", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            enable = 1;
            data_in = 4'h5;
            #1;

            check_outputs(4'h5);
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
        $dumpvars(0,clk, data_in, enable, load, reset, data_out);
    end

endmodule
