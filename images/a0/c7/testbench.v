`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg RESET;
    reg TE;
    wire ENCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN(EN),
        .RESET(RESET),
        .TE(TE),
        .ENCLK(ENCLK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            EN = 0;
            TE = 0;
            @(negedge CLK);
            RESET = 0;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Successful Pulse Generation");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            TE = 1;

            repeat(4) @(negedge CLK);

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: EN drops during sequence");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            TE = 1;
            repeat(2) @(negedge CLK);
            EN = 0;
            repeat(2) @(negedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: TE drops during sequence");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            TE = 1;
            repeat(3) @(negedge CLK);
            TE = 0;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: TE change during active pulse");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            TE = 1;
            repeat(4) @(negedge CLK);
            #2;
            if (ENCLK == 1'b1) begin
                TE = 0;
                #1;
                #1;

                check_outputs(1'b0);
            end else begin
                $display("  Error: Pulse did not start correctly for testcase004");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: RESET during sequence");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            TE = 1;
            repeat(2) @(negedge CLK);
            RESET = 1;
            @(negedge CLK);
            RESET = 0;
            repeat(2) @(negedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Checking state persistence");
            reset_dut();
            @(negedge CLK);
            EN = 1;
            TE = 1;
            repeat(1) @(negedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_ENCLK;
        begin
            if (expected_ENCLK === (expected_ENCLK ^ ENCLK ^ expected_ENCLK)) begin
                $display("PASS");
                $display("  Outputs: ENCLK=%b",
                         ENCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENCLK=%b",
                         expected_ENCLK);
                $display("  Got:      ENCLK=%b",
                         ENCLK);
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
        $dumpvars(0,CLK, EN, RESET, TE, ENCLK);
    end

endmodule
