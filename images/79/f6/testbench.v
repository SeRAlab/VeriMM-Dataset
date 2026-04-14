`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg lio_buscfg_brstlen2_sr;
    reg lio_buscfg_brstlen4_sr;
    reg [7:0] m_cdq_haddr_sr;
    wire [3:0] ibnk_sel_s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lio_buscfg_brstlen2_sr(lio_buscfg_brstlen2_sr),
        .lio_buscfg_brstlen4_sr(lio_buscfg_brstlen4_sr),
        .m_cdq_haddr_sr(m_cdq_haddr_sr),
        .ibnk_sel_s(ibnk_sel_s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Burst length 2, addr=0x03", test_num);
            lio_buscfg_brstlen2_sr = 1'b1;
            lio_buscfg_brstlen4_sr = 1'b0;
            m_cdq_haddr_sr = 8'h03;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Burst length 4, addr=0x03", test_num);
            lio_buscfg_brstlen2_sr = 1'b0;
            lio_buscfg_brstlen4_sr = 1'b1;
            m_cdq_haddr_sr = 8'h03;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Default configuration, addr=0x03", test_num);
            lio_buscfg_brstlen2_sr = 1'b0;
            lio_buscfg_brstlen4_sr = 1'b0;
            m_cdq_haddr_sr = 8'h03;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Burst length 2, addr=0xA9", test_num);
            lio_buscfg_brstlen2_sr = 1'b1;
            lio_buscfg_brstlen4_sr = 1'b0;
            m_cdq_haddr_sr = 8'hA9;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Burst length 4, addr=0xAE", test_num);
            lio_buscfg_brstlen2_sr = 1'b0;
            lio_buscfg_brstlen4_sr = 1'b1;
            m_cdq_haddr_sr = 8'hAE;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Default configuration, addr=0x55", test_num);
            lio_buscfg_brstlen2_sr = 1'b0;
            lio_buscfg_brstlen4_sr = 1'b0;
            m_cdq_haddr_sr = 8'h55;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Burst length 2, addr=0xFF", test_num);
            lio_buscfg_brstlen2_sr = 1'b1;
            lio_buscfg_brstlen4_sr = 1'b0;
            m_cdq_haddr_sr = 8'hFF;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Default configuration, addr=0x00", test_num);
            lio_buscfg_brstlen2_sr = 1'b0;
            lio_buscfg_brstlen4_sr = 1'b0;
            m_cdq_haddr_sr = 8'h00;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_ibnk_sel_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ibnk_sel_s === (expected_ibnk_sel_s ^ ibnk_sel_s ^ expected_ibnk_sel_s)) begin
                $display("PASS");
                $display("  Outputs: ibnk_sel_s=%h",
                         ibnk_sel_s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ibnk_sel_s=%h",
                         expected_ibnk_sel_s);
                $display("  Got:      ibnk_sel_s=%h",
                         ibnk_sel_s);
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
