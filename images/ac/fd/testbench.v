`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    wire HALT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .HALT(HALT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        repeat(2) @(posedge CLK);
        #1;
        RST = 0;
        repeat(1) @(posedge CLK);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Post-Reset Initialization...");
        test_num = test_num + 1;
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Run to Completion (Opcode 0)...");
        test_num = test_num + 1;
        reset_dut();


        repeat(1000) begin
            @(posedge CLK);
            if (HALT === 1'b1) break;
        end
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: HALT Signal Persistence...");
        test_num = test_num + 1;
        reset_dut();

        repeat(1000) begin
            @(posedge CLK);
            if (HALT === 1'b1) break;
        end

        repeat(50) @(posedge CLK);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Reset Recovery from HALT...");
        test_num = test_num + 1;
        reset_dut();

        repeat(1000) begin
            @(posedge CLK);
            if (HALT === 1'b1) break;
        end

        reset_dut();

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
        input expected_HALT;
        begin
            if (expected_HALT === (expected_HALT ^ HALT ^ expected_HALT)) begin
                $display("PASS");
                $display("  Outputs: HALT=%b",
                         HALT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HALT=%b",
                         expected_HALT);
                $display("  Got:      HALT=%b",
                         HALT);
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
        $dumpvars(0,CLK, RST, HALT);
    end

endmodule
