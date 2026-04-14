`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dmem_out_s;
    reg [31:0] exc_addr;
    reg [31:0] hilo;
    reg [2:0] m5reg;
    reg [31:0] npc_0;
    reg [31:0] r;
    wire [31:0] mux_m5reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dmem_out_s(dmem_out_s),
        .exc_addr(exc_addr),
        .hilo(hilo),
        .m5reg(m5reg),
        .npc_0(npc_0),
        .r(r),
        .mux_m5reg(mux_m5reg)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select r (m5reg = 0)", test_num);
            r          = 32'h1111_1111;
            dmem_out_s = 32'h2222_2222;
            npc_0      = 32'h3333_3333;
            hilo       = 32'h4444_4444;
            exc_addr   = 32'h5555_5555;
            m5reg      = 3'd0;
            #1;

            check_outputs(32'h1111_1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select dmem_out_s (m5reg = 1)", test_num);
            r          = 32'hAAAA_AAAA;
            dmem_out_s = 32'hBBBB_BBBB;
            npc_0      = 32'hCCCC_CCCC;
            hilo       = 32'hDDDD_DDDD;
            exc_addr   = 32'hEEEE_EEEE;
            m5reg      = 3'd1;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select npc_0 (m5reg = 2)", test_num);
            r          = 32'h1234_5678;
            dmem_out_s = 32'h8765_4321;
            npc_0      = 32'hDEAD_BEEF;
            hilo       = 32'hFEED_FACE;
            exc_addr   = 32'hCAFE_BABE;
            m5reg      = 3'd2;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select hilo (m5reg = 3)", test_num);
            r          = 32'h0000_0001;
            dmem_out_s = 32'h0000_0002;
            npc_0      = 32'h0000_0003;
            hilo       = 32'h0000_0004;
            exc_addr   = 32'h0000_0005;
            m5reg      = 3'd3;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select exc_addr (m5reg = 4)", test_num);
            r          = 32'hFFFF_FFFF;
            dmem_out_s = 32'hEEEE_EEEE;
            npc_0      = 32'hDDDD_DDDD;
            hilo       = 32'hCCCC_CCCC;
            exc_addr   = 32'hBBBB_BBBB;
            m5reg      = 3'd4;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Dynamic data change on select r (m5reg = 0)", test_num);
            r          = 32'hFEDC_BA98;
            dmem_out_s = 32'h0;
            npc_0      = 32'h0;
            hilo       = 32'h0;
            exc_addr   = 32'h0;
            m5reg      = 3'd0;
            #1;

            check_outputs(32'hFEDC_BA98);
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
        input [31:0] expected_mux_m5reg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_m5reg === (expected_mux_m5reg ^ mux_m5reg ^ expected_mux_m5reg)) begin
                $display("PASS");
                $display("  Outputs: mux_m5reg=%h",
                         mux_m5reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_m5reg=%h",
                         expected_mux_m5reg);
                $display("  Got:      mux_m5reg=%h",
                         mux_m5reg);
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
