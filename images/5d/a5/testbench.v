`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [15:0] cos_out;
    wire [15:0] sine_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .cos_out(cos_out),
        .sine_out(sine_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk = 0;
            reset = 1;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'd15000, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check state after 1 clock cycle", test_num);
            reset_dut();
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'd14997, 16'd234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check state after 2 clock cycles", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;



            #1;




            check_outputs(16'd14990, 16'd468);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check state after 5 clock cycles", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;






            #1;







            check_outputs(16'd14948, 16'd1169);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check state after 10 clock cycles", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;






            #1;







            check_outputs(16'd14803, 16'd2330);
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
        input [15:0] expected_cos_out;
        input [15:0] expected_sine_out;
        begin
            if (expected_cos_out === (expected_cos_out ^ cos_out ^ expected_cos_out) &&
                expected_sine_out === (expected_sine_out ^ sine_out ^ expected_sine_out)) begin
                $display("PASS");
                $display("  Outputs: cos_out=%h, sine_out=%h",
                         cos_out, sine_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cos_out=%h, sine_out=%h",
                         expected_cos_out, expected_sine_out);
                $display("  Got:      cos_out=%h, sine_out=%h",
                         cos_out, sine_out);
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
        $dumpvars(0,clk, reset, cos_out, sine_out);
    end

endmodule
