`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg inClk;
    reg reset;
    wire [3:0] LEDSEL;
    wire [6:0] SSLED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inClk(inClk),
        .reset(reset),
        .LEDSEL(LEDSEL),
        .SSLED(SSLED)
    );

    // Clock generation (10ns period)
    initial begin
        inClk = 0;
        forever #5 inClk = ~inClk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge inClk);
            #2;
            reset = 0;
            @(posedge inClk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(4'b1110, 7'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: 1st Transition", test_num);
            reset_dut();
            @(posedge inClk); #2;
            #1;

            check_outputs(4'b1101, 7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: 2nd Transition", test_num);
            reset_dut();
            repeat(2) @(posedge inClk); #2;
            #1;

            check_outputs(4'b1011, 7'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: 3rd Transition", test_num);
            reset_dut();
            repeat(3) @(posedge inClk); #2;
            #1;

            check_outputs(4'b0111, 7'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Wrap-around/Loop Check", test_num);
            reset_dut();
            repeat(4) @(posedge inClk); #2;

            #1;


            check_outputs(4'b1110, 7'h3F);
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
        input [3:0] expected_LEDSEL;
        input [6:0] expected_SSLED;
        begin
            if (expected_LEDSEL === (expected_LEDSEL ^ LEDSEL ^ expected_LEDSEL) &&
                expected_SSLED === (expected_SSLED ^ SSLED ^ expected_SSLED)) begin
                $display("PASS");
                $display("  Outputs: LEDSEL=%h, SSLED=%h",
                         LEDSEL, SSLED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDSEL=%h, SSLED=%h",
                         expected_LEDSEL, expected_SSLED);
                $display("  Got:      LEDSEL=%h, SSLED=%h",
                         LEDSEL, SSLED);
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
        $dumpvars(0,inClk, reset, LEDSEL, SSLED);
    end

endmodule
