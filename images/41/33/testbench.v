`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in_clk;
    reg in_pulse;
    reg out_clk;
    wire out_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_clk(in_clk),
        .in_pulse(in_pulse),
        .out_clk(out_clk),
        .out_pulse(out_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        in_clk = 0;
        forever #5 in_clk = ~in_clk;
    end

        task reset_dut;

        begin
            in_pulse = 0;
            pulse_caught = 0;
            repeat(10) @(posedge in_clk);
            repeat(10) @(posedge out_clk);
            pulse_caught = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Single Pulse Transfer", test_num);
            reset_dut();

            @(posedge in_clk);
            in_pulse <= 1;
            @(posedge in_clk);
            in_pulse <= 0;


            repeat(10) @(posedge out_clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Idle State (No Input)", test_num);
            reset_dut();


            repeat(15) @(posedge out_clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Successive Pulses", test_num);
            reset_dut();


            @(posedge in_clk);
            in_pulse <= 1;
            @(posedge in_clk);
            in_pulse <= 0;


            repeat(10) @(posedge out_clk);

            if (pulse_caught == 1'b1) begin
                pulse_caught = 0;

                @(posedge in_clk);
                in_pulse <= 1;
                @(posedge in_clk);
                in_pulse <= 0;
                repeat(10) @(posedge out_clk);
                #1;

                check_outputs(1'b1);
            end else begin
                #1;

                check_outputs(1'b1);
            end
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
        input expected_out_pulse;
        begin
            if (expected_out_pulse === (expected_out_pulse ^ out_pulse ^ expected_out_pulse)) begin
                $display("PASS");
                $display("  Outputs: out_pulse=%b",
                         out_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_pulse=%b",
                         expected_out_pulse);
                $display("  Got:      out_pulse=%b",
                         out_pulse);
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
        $dumpvars(0,in_clk, in_pulse, out_clk, out_pulse);
    end

endmodule
