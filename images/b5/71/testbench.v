`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg btn_input;
    reg clk;
    reg reset;
    wire btn_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btn_input(btn_input),
        .clk(clk),
        .reset(reset),
        .btn_output(btn_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            btn_input = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();
            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Short Noise Pulse (5 cycles)", test_num);
            reset_dut();

            @(posedge clk);
            btn_input = 1;
            repeat (5) @(posedge clk);
            btn_input = 0;
            repeat (20) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long Stable Press", test_num);
            reset_dut();

            @(posedge clk);
            btn_input = 1;
            repeat (100) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Press with Glitch", test_num);
            reset_dut();

            @(posedge clk);
            btn_input = 1;
            repeat (10) @(posedge clk);
            btn_input = 0;
            repeat (2) @(posedge clk);
            btn_input = 1;
            repeat (100) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid Press followed by Release", test_num);
            reset_dut();


            @(posedge clk);
            btn_input = 1;
            repeat (100) @(posedge clk);


            btn_input = 0;
            repeat (100) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Frequency Noise Pulses", test_num);
            reset_dut();

            repeat (10) begin
                btn_input = 1;
                @(posedge clk);
                btn_input = 0;
                @(posedge clk);
            end
            repeat (50) @(posedge clk);

            #1;


            check_outputs(1'b0);
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
        input expected_btn_output;
        begin
            if (expected_btn_output === (expected_btn_output ^ btn_output ^ expected_btn_output)) begin
                $display("PASS");
                $display("  Outputs: btn_output=%b",
                         btn_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: btn_output=%b",
                         expected_btn_output);
                $display("  Got:      btn_output=%b",
                         btn_output);
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
        $dumpvars(0,btn_input, clk, reset, btn_output);
    end

endmodule
