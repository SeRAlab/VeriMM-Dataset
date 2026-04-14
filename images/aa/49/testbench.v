`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg data_in;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .data_in(data_in),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("Resetting/Initializing DUT...");
            data_in = 0;
            #100;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("testcase001: High transition density (101010 pattern)");
            reset_dut();


            for (i = 0; i < 100; i = i + 1) begin
                @(posedge clk_in);
                data_in = ~data_in;
            end


            #55;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("testcase002: Low transition density (Run-length testing)");
            reset_dut();
            pattern = 8'b11110000;

            for (i = 0; i < 20; i = i + 1) begin
                data_in = pattern[0]; #10;
                data_in = pattern[1]; #10;
                data_in = pattern[2]; #10;
                data_in = pattern[3]; #10;
                data_in = pattern[4]; #10;
                data_in = pattern[5]; #10;
                data_in = pattern[6]; #10;
                data_in = pattern[7]; #10;
            end

            #45;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("testcase003: Tracking Phase Shift");
            reset_dut();


            for (i = 0; i < 40; i = i + 1) begin
                data_in = ~data_in;
                #10;
            end


            #5;


            for (i = 0; i < 60; i = i + 1) begin
                data_in = ~data_in;
                #10;
            end

            #25;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("testcase004: Fast Data Rate Tracking");
            reset_dut();


            for (i = 0; i < 80; i = i + 1) begin
                data_in = ~data_in;
                #9;
            end

            #50;

            #1;


            check_outputs(1'b1);
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in, data_in, clk_out);
    end

endmodule
