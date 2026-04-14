`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [15:0] x;
    wire [6:0] a_to_g;
    wire [3:0] an;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .x(x),
        .a_to_g(a_to_g),
        .an(an)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            x = 16'h0000;
            @(posedge clk);
            #2;
            clr = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Digit 0 (LSB) for value 4");
            reset_dut();
            x = 16'h1234;

            wait(an == 4'b1110);
            #1;

            #1;


            check_outputs(7'h33, 4'b1110);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking Digit 1 for value 3");
            reset_dut();
            x = 16'h1234;

            wait(an == 4'b1101);
            #1;

            #1;


            check_outputs(7'h79, 4'b1101);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking Digit 2 for value 2");
            reset_dut();
            x = 16'h1234;

            wait(an == 4'b1011);
            #1;

            #1;


            check_outputs(7'h6D, 4'b1011);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking Digit 3 (MSB) for value 1");
            reset_dut();
            x = 16'h1234;

            wait(an == 4'b0111);
            #1;

            #1;


            check_outputs(7'h30, 4'b0111);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking letter 'D'");
            reset_dut();
            x = 16'hABCD;
            wait(an == 4'b1110);
            #1;

            #1;


            check_outputs(7'h3D, 4'b1110);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking letter 'A'");
            reset_dut();
            x = 16'hABCD;
            wait(an == 4'b0111);
            #1;

            #1;


            check_outputs(7'h77, 4'b0111);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Checking if clr resets the divider to start at Digit 0");
            reset_dut();
            x = 16'h5678;

            @(posedge clk);
            #1;

            #1;


            check_outputs(7'h7F, 4'b1110);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Checking Digit 0 for value 0");
            reset_dut();
            x = 16'hFFFF;
            x = 16'h0000;
            wait(an == 4'b1110);
            #1;

            #1;


            check_outputs(7'h7E, 4'b1110);
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
        testcase007();
        testcase008();
        
        
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
        input [6:0] expected_a_to_g;
        input [3:0] expected_an;
        begin
            if (expected_a_to_g === (expected_a_to_g ^ a_to_g ^ expected_a_to_g) &&
                expected_an === (expected_an ^ an ^ expected_an)) begin
                $display("PASS");
                $display("  Outputs: a_to_g=%h, an=%h",
                         a_to_g, an);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_to_g=%h, an=%h",
                         expected_a_to_g, expected_an);
                $display("  Got:      a_to_g=%h, an=%h",
                         a_to_g, an);
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
        $dumpvars(0,clk, clr, x, a_to_g, an);
    end

endmodule
