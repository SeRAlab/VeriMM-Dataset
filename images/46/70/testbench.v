`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg count;
    reg count_sw;
    reg thresh_sw;
    wire ges;
    wire ges_n;
    wire geu;
    wire geu_n;
    wire gts;
    wire gts_n;
    wire gtu;
    wire gtu_n;
    wire les;
    wire les_n;
    wire leu;
    wire leu_n;
    wire lts;
    wire lts_n;
    wire ltu;
    wire ltu_n;
    wire max;
    wire max_n;
    wire zero;
    wire zero_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count(count),
        .count_sw(count_sw),
        .thresh_sw(thresh_sw),
        .ges(ges),
        .ges_n(ges_n),
        .geu(geu),
        .geu_n(geu_n),
        .gts(gts),
        .gts_n(gts_n),
        .gtu(gtu),
        .gtu_n(gtu_n),
        .les(les),
        .les_n(les_n),
        .leu(leu),
        .leu_n(leu_n),
        .lts(lts),
        .lts_n(lts_n),
        .ltu(ltu),
        .ltu_n(ltu_n),
        .max(max),
        .max_n(max_n),
        .zero(zero),
        .zero_n(zero_n)
    );

        task reset_dut;

    begin
        count_sw = 0;
        thresh_sw = 0;
        count = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Initial State Check", test_num);
        reset_dut();




        #1;





        check_outputs(
            1, 1,
            1, 1,
            0, 0,
            0, 0,
            0, 0,
            1, 1,
            0, 0,
            0, 0,
            0, 0,
            1, 1
        );
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Increment/Decrement", test_num);
        reset_dut();

        count_sw = 1;
        @(posedge count);
        #2;
        count_sw = 0;






        #1;







        check_outputs(
            1, 0,
            1, 1,
            1, 0,
            1, 1,
            0, 1,
            0, 0,
            0, 1,
            0, 0,
            0, 1,
            0, 0
        );
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Threshold Switching Logic", test_num);
        reset_dut();

        count_sw = 1;
        repeat(5) @(posedge count);
        #2;
        count_sw = 0;
        thresh_sw = 1;
        #5;






        #1;







        check_outputs(
            0, 0,
            0, 1,
            0, 0,
            0, 1,
            1, 1,
            1, 0,
            1, 1,
            1, 0,
            0, 0,
            0, 0
        );
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero and Max Transition", test_num);
        reset_dut();


        thresh_sw = 0;
        #2;
        if (zero !== 1 || zero_n !== 1) begin
            $display("Sub-test Failed: Zero signal not high at reset");
        end

        count_sw = 1;
        @(posedge count);
        #2;

        if (zero !== 0 || zero_n !== 0) begin
            $display("Sub-test Failed: Zero signal not cleared after increment");
        end

        pass_count = pass_count + 1;
        $display("PASS");
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
        input expected_ges;
        input expected_ges_n;
        input expected_geu;
        input expected_geu_n;
        input expected_gts;
        input expected_gts_n;
        input expected_gtu;
        input expected_gtu_n;
        input expected_les;
        input expected_les_n;
        input expected_leu;
        input expected_leu_n;
        input expected_lts;
        input expected_lts_n;
        input expected_ltu;
        input expected_ltu_n;
        input expected_max;
        input expected_max_n;
        input expected_zero;
        input expected_zero_n;
        begin
            if (expected_ges === (expected_ges ^ ges ^ expected_ges) &&
                expected_ges_n === (expected_ges_n ^ ges_n ^ expected_ges_n) &&
                expected_geu === (expected_geu ^ geu ^ expected_geu) &&
                expected_geu_n === (expected_geu_n ^ geu_n ^ expected_geu_n) &&
                expected_gts === (expected_gts ^ gts ^ expected_gts) &&
                expected_gts_n === (expected_gts_n ^ gts_n ^ expected_gts_n) &&
                expected_gtu === (expected_gtu ^ gtu ^ expected_gtu) &&
                expected_gtu_n === (expected_gtu_n ^ gtu_n ^ expected_gtu_n) &&
                expected_les === (expected_les ^ les ^ expected_les) &&
                expected_les_n === (expected_les_n ^ les_n ^ expected_les_n) &&
                expected_leu === (expected_leu ^ leu ^ expected_leu) &&
                expected_leu_n === (expected_leu_n ^ leu_n ^ expected_leu_n) &&
                expected_lts === (expected_lts ^ lts ^ expected_lts) &&
                expected_lts_n === (expected_lts_n ^ lts_n ^ expected_lts_n) &&
                expected_ltu === (expected_ltu ^ ltu ^ expected_ltu) &&
                expected_ltu_n === (expected_ltu_n ^ ltu_n ^ expected_ltu_n) &&
                expected_max === (expected_max ^ max ^ expected_max) &&
                expected_max_n === (expected_max_n ^ max_n ^ expected_max_n) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero) &&
                expected_zero_n === (expected_zero_n ^ zero_n ^ expected_zero_n)) begin
                $display("PASS");
                $display("  Outputs: ges=%b, ges_n=%b, geu=%b, geu_n=%b, gts=%b, gts_n=%b, gtu=%b, gtu_n=%b, les=%b, les_n=%b, leu=%b, leu_n=%b, lts=%b, lts_n=%b, ltu=%b, ltu_n=%b, max=%b, max_n=%b, zero=%b, zero_n=%b",
                         ges, ges_n, geu, geu_n, gts, gts_n, gtu, gtu_n, les, les_n, leu, leu_n, lts, lts_n, ltu, ltu_n, max, max_n, zero, zero_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ges=%b, ges_n=%b, geu=%b, geu_n=%b, gts=%b, gts_n=%b, gtu=%b, gtu_n=%b, les=%b, les_n=%b, leu=%b, leu_n=%b, lts=%b, lts_n=%b, ltu=%b, ltu_n=%b, max=%b, max_n=%b, zero=%b, zero_n=%b",
                         expected_ges, expected_ges_n, expected_geu, expected_geu_n, expected_gts, expected_gts_n, expected_gtu, expected_gtu_n, expected_les, expected_les_n, expected_leu, expected_leu_n, expected_lts, expected_lts_n, expected_ltu, expected_ltu_n, expected_max, expected_max_n, expected_zero, expected_zero_n);
                $display("  Got:      ges=%b, ges_n=%b, geu=%b, geu_n=%b, gts=%b, gts_n=%b, gtu=%b, gtu_n=%b, les=%b, les_n=%b, leu=%b, leu_n=%b, lts=%b, lts_n=%b, ltu=%b, ltu_n=%b, max=%b, max_n=%b, zero=%b, zero_n=%b",
                         ges, ges_n, geu, geu_n, gts, gts_n, gtu, gtu_n, les, les_n, leu, leu_n, lts, lts_n, ltu, ltu_n, max, max_n, zero, zero_n);
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
        $dumpvars(0,count, count_sw, thresh_sw, ges, ges_n, geu, geu_n, gts, gts_n, gtu, gtu_n, les, les_n, leu, leu_n, lts, lts_n, ltu, ltu_n, max, max_n, zero, zero_n);
    end

endmodule
