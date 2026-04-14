`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk__enable;
    reg reset_n;
    reg [3:0] switches;
    wire [7:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk__enable(clk__enable),
        .reset_n(reset_n),
        .switches(switches),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk__enable = 0;
            switches = 4'b0000;
            reset_n = 1;
            #5;
            reset_n = 0;
            #10;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset check", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable (disabled) check", test_num);
            reset_dut();
            clk__enable = 0;
            switches = 4'b0010;

            force dut.counter = 32'h0FFFFFFF;
            repeat(10) @(posedge clk);
            release dut.counter;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switch[1] (inactive) check", test_num);
            reset_dut();
            clk__enable = 1;
            switches = 4'b0000;

            force dut.counter = 32'h08000000;
            @(posedge clk);
            #1;
            release dut.counter;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LED Increment functional check", test_num);
            reset_dut();
            clk__enable = 1;
            switches = 4'b0010;



            force dut.counter = 32'h08000000;
            @(posedge clk);
            #1;
            release dut.counter;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple increment check", test_num);
            reset_dut();
            clk__enable = 1;
            switches = 4'b0010;


            force dut.counter = 32'h08000000;
            @(posedge clk);
            #1 release dut.counter;
            @(posedge clk);


            force dut.counter = 32'h08000000;
            @(posedge clk);
            #1 release dut.counter;

            #1;


            check_outputs(8'h02);
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
        input [7:0] expected_leds;
        begin
            if (expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: leds=%h",
                         leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds=%h",
                         expected_leds);
                $display("  Got:      leds=%h",
                         leds);
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
        $dumpvars(0,clk, clk__enable, reset_n, switches, leds);
    end

endmodule
