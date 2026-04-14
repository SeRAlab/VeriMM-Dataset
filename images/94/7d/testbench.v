`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [4:0] SW;
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
            SW = 5'b00000;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Test %0d: All Zeros (Even parity, HEX blank)", test_num);


            #1;



            check_outputs(7'b0000000, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            SW = 5'b00001;
            @(posedge CLK);
            #1;
            $display("Running Test %0d: SW=00001 (Odd parity, Upper bits 0)", test_num);


            #1;



            check_outputs(7'b0111111, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            SW = 5'b00010;
            @(posedge CLK);
            #1;
            $display("Running Test %0d: SW=00010 (Even parity, Upper bits 1)", test_num);

            #1;


            check_outputs(7'b0000110, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            SW = 5'b10001;
            @(posedge CLK);
            #1;
            $display("Running Test %0d: SW=10001 (Odd parity, Priority bit 4 set)", test_num);

            #1;


            check_outputs(7'b1111111, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            SW = 5'b11111;
            @(posedge CLK);
            #1;
            $display("Running Test %0d: SW=11111 (Odd parity, HEX pattern F)", test_num);

            #1;


            check_outputs(7'b1110001, 0, 1);
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
        $dumpvars(0,CLK, SW, HEX0, LEDG, LEDR);
    end

endmodule
