`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg acia_tx;
    reg m_ctsn;
    reg m_rxd;
    wire acia_rx;
    wire m_rtsn;
    wire m_txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .acia_tx(acia_tx),
        .m_ctsn(m_ctsn),
        .m_rxd(m_rxd),
        .acia_rx(acia_rx),
        .m_rtsn(m_rtsn),
        .m_txd(m_txd)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All signals Low", test_num);
        acia_tx = 1'b0;
        m_rxd = 1'b0;
        m_ctsn = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All signals High", test_num);
        acia_tx = 1'b1;
        m_rxd = 1'b1;
        m_ctsn = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: TX path High, RX path Low", test_num);
        acia_tx = 1'b1;
        m_rxd = 1'b0;
        m_ctsn = 1'b1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: TX path Low, RX path High", test_num);
        acia_tx = 1'b0;
        m_rxd = 1'b1;
        m_ctsn = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Alternating Bits", test_num);
        acia_tx = 1'b1;
        m_rxd = 1'b1;
        m_ctsn = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: CTSn Toggle Only", test_num);
        acia_tx = 1'b0;
        m_rxd = 1'b0;
        m_ctsn = 1'b1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_acia_rx;
        input expected_m_rtsn;
        input expected_m_txd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_acia_rx === (expected_acia_rx ^ acia_rx ^ expected_acia_rx) &&
                expected_m_rtsn === (expected_m_rtsn ^ m_rtsn ^ expected_m_rtsn) &&
                expected_m_txd === (expected_m_txd ^ m_txd ^ expected_m_txd)) begin
                $display("PASS");
                $display("  Outputs: acia_rx=%b, m_rtsn=%b, m_txd=%b",
                         acia_rx, m_rtsn, m_txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acia_rx=%b, m_rtsn=%b, m_txd=%b",
                         expected_acia_rx, expected_m_rtsn, expected_m_txd);
                $display("  Got:      acia_rx=%b, m_rtsn=%b, m_txd=%b",
                         acia_rx, m_rtsn, m_txd);
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
