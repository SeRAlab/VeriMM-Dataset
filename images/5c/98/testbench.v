`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] SW;
    wire [6:0] HEX0;
    wire [1:0] LEDG;
    wire [1:0] LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .SW(SW),
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
            SW = 4'b0000;
            repeat(5) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            SW = 4'h0;
            repeat(10) @(posedge CLK);

            #1;


            check_outputs(7'h40, 2'bzz, 2'bzz, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            SW = 4'h1;
            repeat(10) @(posedge CLK);

            #1;


            check_outputs(7'h79, 2'bzz, 2'bzz, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            SW = 4'hA;
            repeat(10) @(posedge CLK);

            #1;


            check_outputs(7'h08, 2'bzz, 2'bzz, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            SW = 4'hF;
            repeat(10) @(posedge CLK);

            #1;


            check_outputs(7'h0E, 2'bzz, 2'bzz, 0);
        end
        endtask

    task testcase005;

        reg [1:0] initial_ledg;
        begin
            reset_dut();
            SW = 4'h3;
            repeat(10) @(posedge CLK);
            initial_ledg = LEDG;


            SW = 4'h7;
            repeat(50) @(posedge CLK);



            if (HEX0 === 7'h78 && LEDG !== initial_ledg) begin
                $display("PASS: Test %0d | LED Change detected | HEX0=%b", test_num+1, HEX0);
                pass_count = pass_count + 1;
                test_num = test_num + 1;
            end else begin
                $display("FAIL: Test %0d | LED Change failed or HEX0 wrong", test_num+1);
                fail_count = fail_count + 1;
                test_num = test_num + 1;
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
        input [6:0] expected_HEX0;
        input [1:0] expected_LEDG;
        input [1:0] expected_LEDR;
        begin
            if (expected_HEX0 === (expected_HEX0 ^ HEX0 ^ expected_HEX0) &&
                expected_LEDG === (expected_LEDG ^ LEDG ^ expected_LEDG) &&
                expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: HEX0=%h, LEDG=%h, LEDR=%h",
                         HEX0, LEDG, LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HEX0=%h, LEDG=%h, LEDR=%h",
                         expected_HEX0, expected_LEDG, expected_LEDR);
                $display("  Got:      HEX0=%h, LEDG=%h, LEDR=%h",
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
        $dumpvars(0,CLK, SW, HEX0, LEDG, LEDR);
    end

endmodule
