`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] pc_consalto;
    reg [63:0] pc_sinsalto;
    reg pcsrc;
    wire [63:0] nextpc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc_consalto(pc_consalto),
        .pc_sinsalto(pc_sinsalto),
        .pcsrc(pcsrc),
        .nextpc(nextpc)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select pc_sinsalto (pcsrc=0)", test_num);
        pc_sinsalto = 64'h1234_5678_9ABC_DEF0;
        pc_consalto = 64'hFFFF_FFFF_FFFF_FFFF;
        pcsrc = 1'b0;
        #1;

        check_outputs(64'h1234_5678_9ABC_DEF0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select pc_consalto (pcsrc=1)", test_num);
        pc_sinsalto = 64'h1234_5678_9ABC_DEF0;
        pc_consalto = 64'hFEDC_BA98_7654_3210;
        pcsrc = 1'b1;
        #1;

        check_outputs(64'hFEDC_BA98_7654_3210);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select all zeros on pc_sinsalto", test_num);
        pc_sinsalto = 64'h0000_0000_0000_0000;
        pc_consalto = 64'hAAAA_BBBB_CCCC_DDDD;
        pcsrc = 1'b0;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select all ones on pc_consalto", test_num);
        pc_sinsalto = 64'hAAAA_BBBB_CCCC_DDDD;
        pc_consalto = 64'hFFFF_FFFF_FFFF_FFFF;
        pcsrc = 1'b1;
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits test (pcsrc=0)", test_num);
        pc_sinsalto = 64'h5555_5555_5555_5555;
        pc_consalto = 64'hAAAA_AAAA_AAAA_AAAA;
        pcsrc = 1'b0;
        #1;

        check_outputs(64'h5555_5555_5555_5555);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits test (pcsrc=1)", test_num);
        pc_sinsalto = 64'h5555_5555_5555_5555;
        pc_consalto = 64'hAAAA_AAAA_AAAA_AAAA;
        pcsrc = 1'b1;
        #1;

        check_outputs(64'hAAAA_AAAA_AAAA_AAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High-bit toggling check", test_num);
        pc_sinsalto = 64'h8000_0000_0000_0000;
        pc_consalto = 64'h0000_0000_0000_0001;
        pcsrc = 1'b0;
        #1;

        check_outputs(64'h8000_0000_0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Switching pcsrc with identical inputs", test_num);
        pc_sinsalto = 64'hDEAD_BEEF_CAFE_BABE;
        pc_consalto = 64'hDEAD_BEEF_CAFE_BABE;
        pcsrc = 1'b1;
        #1;

        check_outputs(64'hDEAD_BEEF_CAFE_BABE);
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
        input [63:0] expected_nextpc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nextpc === (expected_nextpc ^ nextpc ^ expected_nextpc)) begin
                $display("PASS");
                $display("  Outputs: nextpc=%h",
                         nextpc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nextpc=%h",
                         expected_nextpc);
                $display("  Got:      nextpc=%h",
                         nextpc);
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
