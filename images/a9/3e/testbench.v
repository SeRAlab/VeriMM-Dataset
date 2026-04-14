`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] ledg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .ledg(ledg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            drive_en = 0;
            pin_reg = 16'h0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Driving 4'hA to lower pins", test_num);
            reset_dut();

            drive_en = 1;
            pin_reg = 16'hFFF A;

            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Driving 4'h5 to lower pins", test_num);
            reset_dut();

            drive_en = 1;
            pin_reg = 16'h0005;

            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Driving 4'hF to lower pins", test_num);
            reset_dut();

            drive_en = 1;
            pin_reg = 16'h123F;

            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Driving 4'h0 to lower pins", test_num);
            reset_dut();

            drive_en = 1;
            pin_reg = 16'hABCD;
            pin_reg[3:0] = 4'h0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Checking LED status during reset", test_num);
            reset = 1;
            drive_en = 1;
            pin_reg = 16'h000C;

            @(posedge clk);
            #2;


            #1;



            check_outputs(4'hC);
            reset = 0;
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
        input [3:0] expected_ledg;
        begin
            if (expected_ledg === (expected_ledg ^ ledg ^ expected_ledg)) begin
                $display("PASS");
                $display("  Outputs: ledg=%h",
                         ledg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ledg=%h",
                         expected_ledg);
                $display("  Got:      ledg=%h",
                         ledg);
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
        $dumpvars(0,clk, reset, ledg);
    end

endmodule
