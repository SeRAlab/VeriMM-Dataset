`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg eqin;
    reg gtin;
    reg ltin;
    reg x0;
    reg x1;
    reg y0;
    reg y1;
    wire eqout;
    wire gtout;
    wire ltout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .eqin(eqin),
        .gtin(gtin),
        .ltin(ltin),
        .x0(x0),
        .x1(x1),
        .y0(y0),
        .y1(y1),
        .eqout(eqout),
        .gtout(gtout),
        .ltout(ltout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=0, Y=0, eqin=1 (Equality check)", test_num);
        x1 = 0; x0 = 0; y1 = 0; y0 = 0;
        eqin = 1; gtin = 0; ltin = 0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=2 (10), Y=0 (00) (MSB Greater-than)", test_num);
        x1 = 1; x0 = 0; y1 = 0; y0 = 0;
        eqin = 1; gtin = 0; ltin = 0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=0 (00), Y=2 (10) (MSB Less-than)", test_num);
        x1 = 0; x0 = 0; y1 = 1; y0 = 0;
        eqin = 1; gtin = 0; ltin = 0;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=1 (01), Y=0 (00) (LSB Greater-than)", test_num);
        x1 = 0; x0 = 1; y1 = 0; y0 = 0;
        eqin = 1; gtin = 0; ltin = 0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=0 (00), Y=1 (01) (LSB Less-than)", test_num);
        x1 = 0; x0 = 0; y1 = 0; y0 = 1;
        eqin = 1; gtin = 0; ltin = 0;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=3, Y=3, gtin=1 (Cascade Greater-than)", test_num);
        x1 = 1; x0 = 1; y1 = 1; y0 = 1;
        eqin = 0; gtin = 1; ltin = 0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=3, Y=3, ltin=1 (Cascade Less-than)", test_num);
        x1 = 1; x0 = 1; y1 = 1; y0 = 1;
        eqin = 0; gtin = 0; ltin = 1;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=1, Y=1, all inputs 0", test_num);
        x1 = 0; x0 = 1; y1 = 0; y0 = 1;
        eqin = 0; gtin = 0; ltin = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=2, Y=1, ltin=1 (Current Greater dominance)", test_num);
        x1 = 1; x0 = 0; y1 = 0; y0 = 1;
        eqin = 0; gtin = 0; ltin = 1;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: X=1, Y=2, gtin=1 (Current Less dominance)", test_num);
        x1 = 0; x0 = 1; y1 = 1; y0 = 0;
        eqin = 0; gtin = 1; ltin = 0;
        #1;

        check_outputs(0, 0, 1);
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
        input expected_eqout;
        input expected_gtout;
        input expected_ltout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eqout === (expected_eqout ^ eqout ^ expected_eqout) &&
                expected_gtout === (expected_gtout ^ gtout ^ expected_gtout) &&
                expected_ltout === (expected_ltout ^ ltout ^ expected_ltout)) begin
                $display("PASS");
                $display("  Outputs: eqout=%b, gtout=%b, ltout=%b",
                         eqout, gtout, ltout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eqout=%b, gtout=%b, ltout=%b",
                         expected_eqout, expected_gtout, expected_ltout);
                $display("  Got:      eqout=%b, gtout=%b, ltout=%b",
                         eqout, gtout, ltout);
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
