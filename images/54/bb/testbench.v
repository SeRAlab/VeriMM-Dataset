`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg areset_l_0;
    reg areset_l_1;
    reg greset_l_0;
    reg greset_l_1;
    reg mem_write_disable_0;
    reg mem_write_disable_1;
    reg mux_drive_disable_0;
    reg mux_drive_disable_1;
    reg scan_enable_0;
    reg scan_enable_1;
    reg sehold_0;
    reg sehold_1;
    reg sig0;
    reg sig1;
    reg sig2;
    reg sig3;
    wire areset_l_0_buf;
    wire areset_l_1_buf;
    wire greset_l_0_buf;
    wire greset_l_1_buf;
    wire mem_write_disable_0_buf;
    wire mem_write_disable_1_buf;
    wire mux_drive_disable_0_buf;
    wire mux_drive_disable_1_buf;
    wire scan_enable_0_buf;
    wire scan_enable_1_buf;
    wire sehold_0_buf;
    wire sehold_1_buf;
    wire sig0_buf;
    wire sig1_buf;
    wire sig2_buf;
    wire sig3_buf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset_l_0(areset_l_0),
        .areset_l_1(areset_l_1),
        .greset_l_0(greset_l_0),
        .greset_l_1(greset_l_1),
        .mem_write_disable_0(mem_write_disable_0),
        .mem_write_disable_1(mem_write_disable_1),
        .mux_drive_disable_0(mux_drive_disable_0),
        .mux_drive_disable_1(mux_drive_disable_1),
        .scan_enable_0(scan_enable_0),
        .scan_enable_1(scan_enable_1),
        .sehold_0(sehold_0),
        .sehold_1(sehold_1),
        .sig0(sig0),
        .sig1(sig1),
        .sig2(sig2),
        .sig3(sig3),
        .areset_l_0_buf(areset_l_0_buf),
        .areset_l_1_buf(areset_l_1_buf),
        .greset_l_0_buf(greset_l_0_buf),
        .greset_l_1_buf(greset_l_1_buf),
        .mem_write_disable_0_buf(mem_write_disable_0_buf),
        .mem_write_disable_1_buf(mem_write_disable_1_buf),
        .mux_drive_disable_0_buf(mux_drive_disable_0_buf),
        .mux_drive_disable_1_buf(mux_drive_disable_1_buf),
        .scan_enable_0_buf(scan_enable_0_buf),
        .scan_enable_1_buf(scan_enable_1_buf),
        .sehold_0_buf(sehold_0_buf),
        .sehold_1_buf(sehold_1_buf),
        .sig0_buf(sig0_buf),
        .sig1_buf(sig1_buf),
        .sig2_buf(sig2_buf),
        .sig3_buf(sig3_buf)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs logic low", test_num);

        areset_l_0 = 0; areset_l_1 = 0; greset_l_0 = 0; greset_l_1 = 0;
        scan_enable_0 = 0; scan_enable_1 = 0; sehold_0 = 0; sehold_1 = 0;
        mux_drive_disable_0 = 0; mux_drive_disable_1 = 0;
        mem_write_disable_0 = 0; mem_write_disable_1 = 0;
        sig0 = 0; sig1 = 0; sig2 = 0; sig3 = 0;

        #10;

        #1;


        check_outputs(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs logic high", test_num);

        areset_l_0 = 0; areset_l_1 = 0; greset_l_0 = 0; greset_l_1 = 0;
        scan_enable_0 = 0; scan_enable_1 = 0; sehold_0 = 0; sehold_1 = 0;
        mux_drive_disable_0 = 0; mux_drive_disable_1 = 0;
        mem_write_disable_0 = 0; mem_write_disable_1 = 0;
        sig0 = 0; sig1 = 0; sig2 = 0; sig3 = 0;
        #5;


        areset_l_0 = 1; areset_l_1 = 1; greset_l_0 = 1; greset_l_1 = 1;
        scan_enable_0 = 1; scan_enable_1 = 1; sehold_0 = 1; sehold_1 = 1;
        mux_drive_disable_0 = 1; mux_drive_disable_1 = 1;
        mem_write_disable_0 = 1; mem_write_disable_1 = 1;
        sig0 = 1; sig1 = 1; sig2 = 1; sig3 = 1;

        #10;
        #1;

        check_outputs(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bank 0 signals logic high, Bank 1 low", test_num);

        areset_l_0 = 0; areset_l_1 = 0; greset_l_0 = 0; greset_l_1 = 0;
        scan_enable_0 = 0; scan_enable_1 = 0; sehold_0 = 0; sehold_1 = 0;
        mux_drive_disable_0 = 0; mux_drive_disable_1 = 0;
        mem_write_disable_0 = 0; mem_write_disable_1 = 0;
        sig0 = 0; sig1 = 0; sig2 = 0; sig3 = 0;
        #5;


        areset_l_0 = 1; greset_l_0 = 1; scan_enable_0 = 1; sehold_0 = 1;
        mux_drive_disable_0 = 1; mem_write_disable_0 = 1; sig0 = 1; sig2 = 1;

        #10;

        #1;


        check_outputs(1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bank 1 signals logic high, Bank 0 low", test_num);

        areset_l_0 = 0; areset_l_1 = 0; greset_l_0 = 0; greset_l_1 = 0;
        scan_enable_0 = 0; scan_enable_1 = 0; sehold_0 = 0; sehold_1 = 0;
        mux_drive_disable_0 = 0; mux_drive_disable_1 = 0;
        mem_write_disable_0 = 0; mem_write_disable_1 = 0;
        sig0 = 0; sig1 = 0; sig2 = 0; sig3 = 0;
        #5;


        areset_l_1 = 1; greset_l_1 = 1; scan_enable_1 = 1; sehold_1 = 1;
        mux_drive_disable_1 = 1; mem_write_disable_1 = 1; sig1 = 1; sig3 = 1;

        #10;
        #1;

        check_outputs(0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checkerboard pattern", test_num);

        areset_l_0 = 0; areset_l_1 = 0; greset_l_0 = 0; greset_l_1 = 0;
        scan_enable_0 = 0; scan_enable_1 = 0; sehold_0 = 0; sehold_1 = 0;
        mux_drive_disable_0 = 0; mux_drive_disable_1 = 0;
        mem_write_disable_0 = 0; mem_write_disable_1 = 0;
        sig0 = 0; sig1 = 0; sig2 = 0; sig3 = 0;
        #5;


        areset_l_0 = 1; areset_l_1 = 0;
        greset_l_0 = 1; greset_l_1 = 0;
        mem_write_disable_0 = 1; mem_write_disable_1 = 0;
        mux_drive_disable_0 = 1; mux_drive_disable_1 = 0;
        scan_enable_0 = 1; scan_enable_1 = 0;
        sehold_0 = 1; sehold_1 = 0;
        sig0 = 1; sig1 = 0;
        sig2 = 1; sig3 = 0;

        #10;
        #1;

        check_outputs(1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0);
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
        input expected_areset_l_0_buf;
        input expected_areset_l_1_buf;
        input expected_greset_l_0_buf;
        input expected_greset_l_1_buf;
        input expected_mem_write_disable_0_buf;
        input expected_mem_write_disable_1_buf;
        input expected_mux_drive_disable_0_buf;
        input expected_mux_drive_disable_1_buf;
        input expected_scan_enable_0_buf;
        input expected_scan_enable_1_buf;
        input expected_sehold_0_buf;
        input expected_sehold_1_buf;
        input expected_sig0_buf;
        input expected_sig1_buf;
        input expected_sig2_buf;
        input expected_sig3_buf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_areset_l_0_buf === (expected_areset_l_0_buf ^ areset_l_0_buf ^ expected_areset_l_0_buf) &&
                expected_areset_l_1_buf === (expected_areset_l_1_buf ^ areset_l_1_buf ^ expected_areset_l_1_buf) &&
                expected_greset_l_0_buf === (expected_greset_l_0_buf ^ greset_l_0_buf ^ expected_greset_l_0_buf) &&
                expected_greset_l_1_buf === (expected_greset_l_1_buf ^ greset_l_1_buf ^ expected_greset_l_1_buf) &&
                expected_mem_write_disable_0_buf === (expected_mem_write_disable_0_buf ^ mem_write_disable_0_buf ^ expected_mem_write_disable_0_buf) &&
                expected_mem_write_disable_1_buf === (expected_mem_write_disable_1_buf ^ mem_write_disable_1_buf ^ expected_mem_write_disable_1_buf) &&
                expected_mux_drive_disable_0_buf === (expected_mux_drive_disable_0_buf ^ mux_drive_disable_0_buf ^ expected_mux_drive_disable_0_buf) &&
                expected_mux_drive_disable_1_buf === (expected_mux_drive_disable_1_buf ^ mux_drive_disable_1_buf ^ expected_mux_drive_disable_1_buf) &&
                expected_scan_enable_0_buf === (expected_scan_enable_0_buf ^ scan_enable_0_buf ^ expected_scan_enable_0_buf) &&
                expected_scan_enable_1_buf === (expected_scan_enable_1_buf ^ scan_enable_1_buf ^ expected_scan_enable_1_buf) &&
                expected_sehold_0_buf === (expected_sehold_0_buf ^ sehold_0_buf ^ expected_sehold_0_buf) &&
                expected_sehold_1_buf === (expected_sehold_1_buf ^ sehold_1_buf ^ expected_sehold_1_buf) &&
                expected_sig0_buf === (expected_sig0_buf ^ sig0_buf ^ expected_sig0_buf) &&
                expected_sig1_buf === (expected_sig1_buf ^ sig1_buf ^ expected_sig1_buf) &&
                expected_sig2_buf === (expected_sig2_buf ^ sig2_buf ^ expected_sig2_buf) &&
                expected_sig3_buf === (expected_sig3_buf ^ sig3_buf ^ expected_sig3_buf)) begin
                $display("PASS");
                $display("  Outputs: areset_l_0_buf=%b, areset_l_1_buf=%b, greset_l_0_buf=%b, greset_l_1_buf=%b, mem_write_disable_0_buf=%b, mem_write_disable_1_buf=%b, mux_drive_disable_0_buf=%b, mux_drive_disable_1_buf=%b, scan_enable_0_buf=%b, scan_enable_1_buf=%b, sehold_0_buf=%b, sehold_1_buf=%b, sig0_buf=%b, sig1_buf=%b, sig2_buf=%b, sig3_buf=%b",
                         areset_l_0_buf, areset_l_1_buf, greset_l_0_buf, greset_l_1_buf, mem_write_disable_0_buf, mem_write_disable_1_buf, mux_drive_disable_0_buf, mux_drive_disable_1_buf, scan_enable_0_buf, scan_enable_1_buf, sehold_0_buf, sehold_1_buf, sig0_buf, sig1_buf, sig2_buf, sig3_buf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: areset_l_0_buf=%b, areset_l_1_buf=%b, greset_l_0_buf=%b, greset_l_1_buf=%b, mem_write_disable_0_buf=%b, mem_write_disable_1_buf=%b, mux_drive_disable_0_buf=%b, mux_drive_disable_1_buf=%b, scan_enable_0_buf=%b, scan_enable_1_buf=%b, sehold_0_buf=%b, sehold_1_buf=%b, sig0_buf=%b, sig1_buf=%b, sig2_buf=%b, sig3_buf=%b",
                         expected_areset_l_0_buf, expected_areset_l_1_buf, expected_greset_l_0_buf, expected_greset_l_1_buf, expected_mem_write_disable_0_buf, expected_mem_write_disable_1_buf, expected_mux_drive_disable_0_buf, expected_mux_drive_disable_1_buf, expected_scan_enable_0_buf, expected_scan_enable_1_buf, expected_sehold_0_buf, expected_sehold_1_buf, expected_sig0_buf, expected_sig1_buf, expected_sig2_buf, expected_sig3_buf);
                $display("  Got:      areset_l_0_buf=%b, areset_l_1_buf=%b, greset_l_0_buf=%b, greset_l_1_buf=%b, mem_write_disable_0_buf=%b, mem_write_disable_1_buf=%b, mux_drive_disable_0_buf=%b, mux_drive_disable_1_buf=%b, scan_enable_0_buf=%b, scan_enable_1_buf=%b, sehold_0_buf=%b, sehold_1_buf=%b, sig0_buf=%b, sig1_buf=%b, sig2_buf=%b, sig3_buf=%b",
                         areset_l_0_buf, areset_l_1_buf, greset_l_0_buf, greset_l_1_buf, mem_write_disable_0_buf, mem_write_disable_1_buf, mux_drive_disable_0_buf, mux_drive_disable_1_buf, scan_enable_0_buf, scan_enable_1_buf, sehold_0_buf, sehold_1_buf, sig0_buf, sig1_buf, sig2_buf, sig3_buf);
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
