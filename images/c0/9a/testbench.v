`timescale 1ns/1ps

module clk_delay_tb;

    // Testbench signals (sequential circuit)
    reg M1;
    reg T1;
    reg busrq;
    reg clk;
    reg in_intr;
    reg latch_wait;
    reg mwait;
    reg nreset;
    reg setM1;
    wire busack;
    wire hold_clk_busrq;
    wire hold_clk_iorq;
    wire hold_clk_wait;
    wire iorq_Tw;
    wire nhold_clk_wait;
    wire pin_control_oe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clk_delay dut (
        .M1(M1),
        .T1(T1),
        .busrq(busrq),
        .clk(clk),
        .in_intr(in_intr),
        .latch_wait(latch_wait),
        .mwait(mwait),
        .nreset(nreset),
        .setM1(setM1),
        .busack(busack),
        .hold_clk_busrq(hold_clk_busrq),
        .hold_clk_iorq(hold_clk_iorq),
        .hold_clk_wait(hold_clk_wait),
        .iorq_Tw(iorq_Tw),
        .nhold_clk_wait(nhold_clk_wait),
        .pin_control_oe(pin_control_oe)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clk_delay Testbench");
        $display("========================================");


        
        
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
        input expected_busack;
        input expected_hold_clk_busrq;
        input expected_hold_clk_iorq;
        input expected_hold_clk_wait;
        input expected_iorq_Tw;
        input expected_nhold_clk_wait;
        input expected_pin_control_oe;
        begin
            if (expected_busack === (expected_busack ^ busack ^ expected_busack) &&
                expected_hold_clk_busrq === (expected_hold_clk_busrq ^ hold_clk_busrq ^ expected_hold_clk_busrq) &&
                expected_hold_clk_iorq === (expected_hold_clk_iorq ^ hold_clk_iorq ^ expected_hold_clk_iorq) &&
                expected_hold_clk_wait === (expected_hold_clk_wait ^ hold_clk_wait ^ expected_hold_clk_wait) &&
                expected_iorq_Tw === (expected_iorq_Tw ^ iorq_Tw ^ expected_iorq_Tw) &&
                expected_nhold_clk_wait === (expected_nhold_clk_wait ^ nhold_clk_wait ^ expected_nhold_clk_wait) &&
                expected_pin_control_oe === (expected_pin_control_oe ^ pin_control_oe ^ expected_pin_control_oe)) begin
                $display("PASS");
                $display("  Outputs: busack=%b, hold_clk_busrq=%b, hold_clk_iorq=%b, hold_clk_wait=%b, iorq_Tw=%b, nhold_clk_wait=%b, pin_control_oe=%b",
                         busack, hold_clk_busrq, hold_clk_iorq, hold_clk_wait, iorq_Tw, nhold_clk_wait, pin_control_oe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busack=%b, hold_clk_busrq=%b, hold_clk_iorq=%b, hold_clk_wait=%b, iorq_Tw=%b, nhold_clk_wait=%b, pin_control_oe=%b",
                         expected_busack, expected_hold_clk_busrq, expected_hold_clk_iorq, expected_hold_clk_wait, expected_iorq_Tw, expected_nhold_clk_wait, expected_pin_control_oe);
                $display("  Got:      busack=%b, hold_clk_busrq=%b, hold_clk_iorq=%b, hold_clk_wait=%b, iorq_Tw=%b, nhold_clk_wait=%b, pin_control_oe=%b",
                         busack, hold_clk_busrq, hold_clk_iorq, hold_clk_wait, iorq_Tw, nhold_clk_wait, pin_control_oe);
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
        $dumpvars(0,M1, T1, busrq, clk, in_intr, latch_wait, mwait, nreset, setM1, busack, hold_clk_busrq, hold_clk_iorq, hold_clk_wait, iorq_Tw, nhold_clk_wait, pin_control_oe);
    end

endmodule
