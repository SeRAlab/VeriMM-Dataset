`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg SW0;
    reg SW1;
    reg SW2;
    reg SW3;
    reg SW4;
    wire [6:0] HEX0;
    wire LEDG;
    wire LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .SW0(SW0),
        .SW1(SW1),
        .SW2(SW2),
        .SW3(SW3),
        .SW4(SW4),
        .HEX0(HEX0),
        .LEDG(LEDG),
        .LEDR(LEDR)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            SW4 = 0; SW3 = 0; SW2 = 0; SW1 = 0; SW0 = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Input 0 (00000)", test_num);
            SW4=0; SW3=0; SW2=0; SW1=0; SW0=0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(HEX_0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Input 1 (00001)", test_num);
            SW4=0; SW3=0; SW2=0; SW1=0; SW0=1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(HEX_1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Input 5 (00101)", test_num);
            SW4=0; SW3=0; SW2=1; SW1=0; SW0=1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(HEX_5, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Input 9 (01001)", test_num);
            SW4=0; SW3=1; SW2=0; SW1=0; SW0=1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(HEX_9, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Input 10 (01010)", test_num);
            SW4=0; SW3=1; SW2=0; SW1=1; SW0=0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(HEX_E, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Input 31 (11111)", test_num);
            SW4=1; SW3=1; SW2=1; SW1=1; SW0=1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(HEX_E, 1'b0, 1'b1);
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
        input [6:0] expected_HEX0;
        input expected_LEDG;
        input expected_LEDR;
        begin
            if (expected_HEX0 === (expected_HEX0 ^ HEX0 ^ expected_HEX0) &&
                expected_LEDG === (expected_LEDG ^ LEDG ^ expected_LEDG) &&
                expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: HEX0=%h, LEDG=%b, LEDR=%b",
                         HEX0, LEDG, LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HEX0=%h, LEDG=%b, LEDR=%b",
                         expected_HEX0, expected_LEDG, expected_LEDR);
                $display("  Got:      HEX0=%h, LEDG=%b, LEDR=%b",
                         HEX0, LEDG, LEDR);
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
        $dumpvars(0,CLK, SW0, SW1, SW2, SW3, SW4, HEX0, LEDG, LEDR);
    end

endmodule
