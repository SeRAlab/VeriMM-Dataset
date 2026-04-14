`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ARST;
    reg CLK;
    reg [1:0] cntr;
    wire [15:0] cosine;
    wire [15:0] sine;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ARST(ARST),
        .CLK(CLK),
        .cntr(cntr),
        .cosine(cosine),
        .sine(sine)
    );

    // Clock generation (10ns period)
    initial begin
        ARST = 0;
        forever #5 ARST = ~ARST;
    end

        task reset_dut;

        begin
            ARST = 1;
            cntr = 0;
            #20;
            ARST = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            cntr = 2'b00;
            #20;
            $display("Testcase %0d: Angle 0 degrees (cntr=00)", test_num);
            #1;

            check_outputs(16'h7FFF, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            cntr = 2'b01;
            #20;
            $display("Testcase %0d: Angle 90 degrees (cntr=01)", test_num);
            #1;

            check_outputs(16'h0000, 16'h7FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            cntr = 2'b10;
            #20;
            $display("Testcase %0d: Angle 180 degrees (cntr=10)", test_num);
            #1;

            check_outputs(16'h8000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            cntr = 2'b11;
            #20;
            $display("Testcase %0d: Angle 270 degrees (cntr=11)", test_num);
            #1;

            check_outputs(16'h0000, 16'h8000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            cntr = 2'b11;
            #10;
            ARST = 1;
            #10;
            $display("Testcase %0d: Asynchronous Reset check", test_num);

            #1;


            check_outputs(16'h7FFF, 16'h0000);
            ARST = 0;
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
        input [15:0] expected_cosine;
        input [15:0] expected_sine;
        begin
            if (expected_cosine === (expected_cosine ^ cosine ^ expected_cosine) &&
                expected_sine === (expected_sine ^ sine ^ expected_sine)) begin
                $display("PASS");
                $display("  Outputs: cosine=%h, sine=%h",
                         cosine, sine);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cosine=%h, sine=%h",
                         expected_cosine, expected_sine);
                $display("  Got:      cosine=%h, sine=%h",
                         cosine, sine);
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
        $dumpvars(0,ARST, CLK, cntr, cosine, sine);
    end

endmodule
