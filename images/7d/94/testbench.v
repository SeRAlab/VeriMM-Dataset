`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pl_btn;
    reg sgmii_refclk_n;
    reg sgmii_refclk_p;
    reg [3:0] sgmii_rxn;
    reg [3:0] sgmii_rxp;
    wire mdio_mdc;
    wire [1:0] pl_led;
    wire [1:0] pl_pmod;
    wire [3:0] sgmii_txn;
    wire [3:0] sgmii_txp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pl_btn(pl_btn),
        .sgmii_refclk_n(sgmii_refclk_n),
        .sgmii_refclk_p(sgmii_refclk_p),
        .sgmii_rxn(sgmii_rxn),
        .sgmii_rxp(sgmii_rxp),
        .mdio_mdc(mdio_mdc),
        .pl_led(pl_led),
        .pl_pmod(pl_pmod),
        .sgmii_txn(sgmii_txn),
        .sgmii_txp(sgmii_txp)
    );

        task reset_dut;

    begin
        pl_btn = 0;
        sgmii_rxp = 4'b0000;
        sgmii_rxn = 4'b1111;
        #100;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: SGMII Inversion Logic", test_num);
        reset_dut();
        sgmii_rxp = 4'b1010;
        sgmii_rxn = 4'b0101;
        #20;

        #1;


        check_outputs(1'b0, 2'b00, 2'b00, 4'b1010, 4'b0101);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: MDIO MDC Button Control (Active)", test_num);
        reset_dut();
        pl_btn = 1;
        sgmii_rxp = 4'b1111;
        sgmii_rxn = 4'b0000;
        #20;

        #1;


        check_outputs(1'b1, 2'b00, 2'b00, 4'b1111, 4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: SGMII Walking Bit Pattern", test_num);
        reset_dut();
        sgmii_rxp = 4'b0001;
        sgmii_rxn = 4'b1110;
        #20;
        #1;

        check_outputs(1'b0, 2'b00, 2'b00, 4'b1110, 4'b1110);

        sgmii_rxp = 4'b1000;
        sgmii_rxn = 4'b0111;
        #20;
        #1;

        check_outputs(1'b0, 2'b00, 2'b00, 4'b0111, 4'b0111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: LED/PMOD Monitoring Initial State", test_num);
        reset_dut();
        #500;

        #1;


        check_outputs(1'b0, 2'b00, 2'b00, 4'b1111, 4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: MDIO MDC Button Toggle", test_num);
        reset_dut();
        pl_btn = 1; #50;
        pl_btn = 0; #50;
        pl_btn = 1; #50;
        #1;

        check_outputs(1'b1, 2'b00, 2'b00, 4'b1111, 4'b1111);
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
        input expected_mdio_mdc;
        input [1:0] expected_pl_led;
        input [1:0] expected_pl_pmod;
        input [3:0] expected_sgmii_txn;
        input [3:0] expected_sgmii_txp;
        begin
            if (expected_mdio_mdc === (expected_mdio_mdc ^ mdio_mdc ^ expected_mdio_mdc) &&
                expected_pl_led === (expected_pl_led ^ pl_led ^ expected_pl_led) &&
                expected_pl_pmod === (expected_pl_pmod ^ pl_pmod ^ expected_pl_pmod) &&
                expected_sgmii_txn === (expected_sgmii_txn ^ sgmii_txn ^ expected_sgmii_txn) &&
                expected_sgmii_txp === (expected_sgmii_txp ^ sgmii_txp ^ expected_sgmii_txp)) begin
                $display("PASS");
                $display("  Outputs: mdio_mdc=%b, pl_led=%h, pl_pmod=%h, sgmii_txn=%h, sgmii_txp=%h",
                         mdio_mdc, pl_led, pl_pmod, sgmii_txn, sgmii_txp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mdio_mdc=%b, pl_led=%h, pl_pmod=%h, sgmii_txn=%h, sgmii_txp=%h",
                         expected_mdio_mdc, expected_pl_led, expected_pl_pmod, expected_sgmii_txn, expected_sgmii_txp);
                $display("  Got:      mdio_mdc=%b, pl_led=%h, pl_pmod=%h, sgmii_txn=%h, sgmii_txp=%h",
                         mdio_mdc, pl_led, pl_pmod, sgmii_txn, sgmii_txp);
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
        $dumpvars(0,pl_btn, sgmii_refclk_n, sgmii_refclk_p, sgmii_rxn, sgmii_rxp, mdio_mdc, pl_led, pl_pmod, sgmii_txn, sgmii_txp);
    end

endmodule
