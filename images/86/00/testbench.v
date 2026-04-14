`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg DOWN;
    reg EN;
    reg LOAD;
    reg RESET;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .DOWN(DOWN),
        .EN(EN),
        .LOAD(LOAD),
        .RESET(RESET),
        .Q(Q)
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
            LOAD = 0;
            DOWN = 0;
            D = 0;
            @(posedge CLK);
            #1;
            RESET = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Synchronous Reset Check");
            reset_dut();
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Parallel Load Check");
            reset_dut();
            @(posedge CLK);
            D = 8'hA5;
            LOAD = 1;
            EN = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Increment Check");
            reset_dut();
            EN = 1;
            LOAD = 0;
            DOWN = 0;

            repeat(10) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Decrement Check");
            reset_dut();

            D = 8'h0F;
            LOAD = 1;
            EN = 1;
            @(posedge CLK);

            LOAD = 0;
            DOWN = 1;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Enable Inhibition Check");
            reset_dut();
            EN = 0;
            LOAD = 0;
            DOWN = 0;
            repeat(10) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Overflow Check (0xFF -> 0x00)");
            reset_dut();
            D = 8'hFF;
            LOAD = 1;
            EN = 1;
            @(posedge CLK);
            LOAD = 0;
            DOWN = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Underflow Check (0x00 -> 0xFF)");
            reset_dut();
            EN = 1;
            LOAD = 0;
            DOWN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Load Priority Check");
            reset_dut();
            EN = 1;
            D = 8'h55;
            LOAD = 1;
            DOWN = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: Complex Sequence Check");
            reset_dut();

            D = 8'h10; LOAD = 1; EN = 1; @(posedge CLK);

            LOAD = 0; DOWN = 0; repeat(2) @(posedge CLK);

            EN = 0; repeat(5) @(posedge CLK);

            EN = 1; DOWN = 1; repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase010;

        begin
            $display("Running Testcase 010: Reset Priority Check");
            reset_dut();
            EN = 1;
            LOAD = 1;
            D = 8'hFF;
            RESET = 1;
            @(posedge CLK);
            #1;
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, D, DOWN, EN, LOAD, RESET, Q);
    end

endmodule
