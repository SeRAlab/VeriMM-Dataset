`timescale 1ns/1ps

module control_pins_n_tb;

    // Testbench signals (combinational circuit)
    reg CPUCLK;
    reg busack;
    reg in_halt;
    reg nIORQ_out;
    reg nM1_out;
    reg nMREQ_out;
    reg nRD_out;
    reg nRFSH_out;
    reg nWR_out;
    reg pin_control_oe;
    reg pin_nBUSRQ;
    reg pin_nINT;
    reg pin_nNMI;
    reg pin_nRESET;
    reg pin_nWAIT;
    wire busrq;
    wire clk;
    wire intr;
    wire mwait;
    wire nmi;
    wire pin_nBUSACK;
    wire pin_nHALT;
    wire pin_nIORQ;
    wire pin_nM1;
    wire pin_nMREQ;
    wire pin_nRD;
    wire pin_nRFSH;
    wire pin_nWR;
    wire reset_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    control_pins_n dut (
        .CPUCLK(CPUCLK),
        .busack(busack),
        .in_halt(in_halt),
        .nIORQ_out(nIORQ_out),
        .nM1_out(nM1_out),
        .nMREQ_out(nMREQ_out),
        .nRD_out(nRD_out),
        .nRFSH_out(nRFSH_out),
        .nWR_out(nWR_out),
        .pin_control_oe(pin_control_oe),
        .pin_nBUSRQ(pin_nBUSRQ),
        .pin_nINT(pin_nINT),
        .pin_nNMI(pin_nNMI),
        .pin_nRESET(pin_nRESET),
        .pin_nWAIT(pin_nWAIT),
        .busrq(busrq),
        .clk(clk),
        .intr(intr),
        .mwait(mwait),
        .nmi(nmi),
        .pin_nBUSACK(pin_nBUSACK),
        .pin_nHALT(pin_nHALT),
        .pin_nIORQ(pin_nIORQ),
        .pin_nM1(pin_nM1),
        .pin_nMREQ(pin_nMREQ),
        .pin_nRD(pin_nRD),
        .pin_nRFSH(pin_nRFSH),
        .pin_nWR(pin_nWR),
        .reset_in(reset_in)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("control_pins_n Testbench");
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
        input expected_busrq;
        input expected_clk;
        input expected_intr;
        input expected_mwait;
        input expected_nmi;
        input expected_pin_nBUSACK;
        input expected_pin_nHALT;
        input expected_pin_nIORQ;
        input expected_pin_nM1;
        input expected_pin_nMREQ;
        input expected_pin_nRD;
        input expected_pin_nRFSH;
        input expected_pin_nWR;
        input expected_reset_in;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_busrq === (expected_busrq ^ busrq ^ expected_busrq) &&
                expected_clk === (expected_clk ^ clk ^ expected_clk) &&
                expected_intr === (expected_intr ^ intr ^ expected_intr) &&
                expected_mwait === (expected_mwait ^ mwait ^ expected_mwait) &&
                expected_nmi === (expected_nmi ^ nmi ^ expected_nmi) &&
                expected_pin_nBUSACK === (expected_pin_nBUSACK ^ pin_nBUSACK ^ expected_pin_nBUSACK) &&
                expected_pin_nHALT === (expected_pin_nHALT ^ pin_nHALT ^ expected_pin_nHALT) &&
                expected_pin_nIORQ === (expected_pin_nIORQ ^ pin_nIORQ ^ expected_pin_nIORQ) &&
                expected_pin_nM1 === (expected_pin_nM1 ^ pin_nM1 ^ expected_pin_nM1) &&
                expected_pin_nMREQ === (expected_pin_nMREQ ^ pin_nMREQ ^ expected_pin_nMREQ) &&
                expected_pin_nRD === (expected_pin_nRD ^ pin_nRD ^ expected_pin_nRD) &&
                expected_pin_nRFSH === (expected_pin_nRFSH ^ pin_nRFSH ^ expected_pin_nRFSH) &&
                expected_pin_nWR === (expected_pin_nWR ^ pin_nWR ^ expected_pin_nWR) &&
                expected_reset_in === (expected_reset_in ^ reset_in ^ expected_reset_in)) begin
                $display("PASS");
                $display("  Outputs: busrq=%b, clk=%b, intr=%b, mwait=%b, nmi=%b, pin_nBUSACK=%b, pin_nHALT=%b, pin_nIORQ=%b, pin_nM1=%b, pin_nMREQ=%b, pin_nRD=%b, pin_nRFSH=%b, pin_nWR=%b, reset_in=%b",
                         busrq, clk, intr, mwait, nmi, pin_nBUSACK, pin_nHALT, pin_nIORQ, pin_nM1, pin_nMREQ, pin_nRD, pin_nRFSH, pin_nWR, reset_in);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busrq=%b, clk=%b, intr=%b, mwait=%b, nmi=%b, pin_nBUSACK=%b, pin_nHALT=%b, pin_nIORQ=%b, pin_nM1=%b, pin_nMREQ=%b, pin_nRD=%b, pin_nRFSH=%b, pin_nWR=%b, reset_in=%b",
                         expected_busrq, expected_clk, expected_intr, expected_mwait, expected_nmi, expected_pin_nBUSACK, expected_pin_nHALT, expected_pin_nIORQ, expected_pin_nM1, expected_pin_nMREQ, expected_pin_nRD, expected_pin_nRFSH, expected_pin_nWR, expected_reset_in);
                $display("  Got:      busrq=%b, clk=%b, intr=%b, mwait=%b, nmi=%b, pin_nBUSACK=%b, pin_nHALT=%b, pin_nIORQ=%b, pin_nM1=%b, pin_nMREQ=%b, pin_nRD=%b, pin_nRFSH=%b, pin_nWR=%b, reset_in=%b",
                         busrq, clk, intr, mwait, nmi, pin_nBUSACK, pin_nHALT, pin_nIORQ, pin_nM1, pin_nMREQ, pin_nRD, pin_nRFSH, pin_nWR, reset_in);
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

endmodule
