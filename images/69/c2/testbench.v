`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset;
    wire [7:0] count;
    wire [7:0] final_output;
    wire [7:0] toggled;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .count(count),
        .final_output(final_output),
        .toggled(toggled)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: All zeros", test_num);
            reset_dut();
            in = 8'h00;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All ones", test_num);
            reset_dut();
            in = 8'hFF;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h08, 8'h07, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Sequential Toggling", test_num);
            reset_dut();

            in = 8'hAA;
            @(posedge clk);
            #1;





            in = 8'hAA;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h04, 8'h04, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Alternating bits pattern", test_num);
            reset_dut();
            in = 8'h55;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h04, 8'h59, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multi-step accumulation", test_num);
            reset_dut();

            in = 8'h01; @(posedge clk); #1;

            in = 8'h02; @(posedge clk); #1;

            in = 8'h04; @(posedge clk); #1;

            in = 8'h08; @(posedge clk); #1;



            #1;




            check_outputs(8'h01, 8'h10, 8'h0F);
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
        input [7:0] expected_count;
        input [7:0] expected_final_output;
        input [7:0] expected_toggled;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_toggled === (expected_toggled ^ toggled ^ expected_toggled)) begin
                $display("PASS");
                $display("  Outputs: count=%h, final_output=%h, toggled=%h",
                         count, final_output, toggled);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, final_output=%h, toggled=%h",
                         expected_count, expected_final_output, expected_toggled);
                $display("  Got:      count=%h, final_output=%h, toggled=%h",
                         count, final_output, toggled);
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
        $dumpvars(0,clk, in, reset, count, final_output, toggled);
    end

endmodule
