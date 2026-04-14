`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg reset;
    reg wenb;
    wire [7:0] reg_0x36;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .reset(reset),
        .wenb(wenb),
        .reg_0x36(reg_0x36)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            wenb = 1;
            in_data = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking simple write (0xA5)...", test_num);
            reset_dut();
            in_data = 8'hA5;
            wenb = 0;
            @(posedge clk);
            #2;
            wenb = 1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking write disable (wenb=1)...", test_num);
            reset_dut();


            in_data = 8'h55;
            wenb = 0;
            @(posedge clk);
            #2;


            in_data = 8'hAA;
            wenb = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking consecutive writes...", test_num);
            reset_dut();


            in_data = 8'h11;
            wenb = 0;
            @(posedge clk);
            #2;


            in_data = 8'h22;
            wenb = 0;
            @(posedge clk);
            #2;


            in_data = 8'h33;
            wenb = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Checking boundary values (0xFF then 0x00)...", test_num);
            reset_dut();


            in_data = 8'hFF;
            wenb = 0;
            @(posedge clk);
            #2;


            in_data = 8'h00;
            wenb = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Checking reset during operation...", test_num);
            reset_dut();


            in_data = 8'h99;
            wenb = 0;
            @(posedge clk);
            #2;


            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;

            #1;


            check_outputs(8'h00);
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
        input [7:0] expected_reg_0x36;
        begin
            if (expected_reg_0x36 === (expected_reg_0x36 ^ reg_0x36 ^ expected_reg_0x36)) begin
                $display("PASS");
                $display("  Outputs: reg_0x36=%h",
                         reg_0x36);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_0x36=%h",
                         expected_reg_0x36);
                $display("  Got:      reg_0x36=%h",
                         reg_0x36);
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
        $dumpvars(0,clk, in_data, reset, wenb, reg_0x36);
    end

endmodule
