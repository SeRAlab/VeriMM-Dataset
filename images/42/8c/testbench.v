`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] SW0;
    reg [1:0] SW1;
    reg clk;
    reg [11:0] sig_sine;
    reg [11:0] sig_square;
    wire [23:0] sig;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW0(SW0),
        .SW1(SW1),
        .clk(clk),
        .sig_sine(sig_sine),
        .sig_square(sig_square),
        .sig(sig)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            SW0 = 2'b00;
            SW1 = 2'b00;
            sig_sine = 12'h000;
            sig_square = 12'h000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Selecting Sine Wave (SW0=01, SW1=00)", test_num);
            SW0 = 2'b01;
            SW1 = 2'b00;
            sig_sine = 12'hA5A;
            sig_square = 12'h5A5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hA5A000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Selecting Square Wave (SW0=00, SW1=01)", test_num);
            SW0 = 2'b00;
            SW1 = 2'b01;
            sig_sine = 12'hAAA;
            sig_square = 12'hFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFFF000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: No selection (SW0=00, SW1=00)", test_num);
            SW0 = 2'b00;
            SW1 = 2'b00;
            sig_sine = 12'hABC;
            sig_square = 12'hDEF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Priority Check (SW0=01, SW1=01)", test_num);
            SW0 = 2'b01;
            SW1 = 2'b01;
            sig_sine = 12'h888;
            sig_square = 12'h444;
            @(posedge clk);
            #2;

            #1;


            check_outputs(24'h888000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Boundary values (Max signal values)", test_num);
            SW0 = 2'b01;
            SW1 = 2'b00;
            sig_sine = 12'hFFF;
            sig_square = 12'hFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFFF000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Dynamic input update", test_num);
            SW0 = 2'b01;
            SW1 = 2'b00;
            sig_sine = 12'h123;
            @(posedge clk);
            #2;

            sig_sine = 12'h456;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h456000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %0d: Switch transition Sine to Square", test_num);
            SW0 = 2'b01;
            SW1 = 2'b00;
            sig_sine = 12'hAAA;
            sig_square = 12'h555;
            @(posedge clk);
            #2;
            SW0 = 2'b00;
            SW1 = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h555000);
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
        input [23:0] expected_sig;
        begin
            if (expected_sig === (expected_sig ^ sig ^ expected_sig)) begin
                $display("PASS");
                $display("  Outputs: sig=%h",
                         sig);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sig=%h",
                         expected_sig);
                $display("  Got:      sig=%h",
                         sig);
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
        $dumpvars(0,SW0, SW1, clk, sig_sine, sig_square, sig);
    end

endmodule
