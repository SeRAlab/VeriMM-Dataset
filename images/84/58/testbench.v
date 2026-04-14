`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg count_sw;
    reg thresh_sw;
    reg [31:0] threshold;
    wire [31:0] count;
    wire ges;
    wire geu;
    wire gts;
    wire gtu;
    wire les;
    wire leu;
    wire lts;
    wire ltu;
    wire max;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count_sw(count_sw),
        .thresh_sw(thresh_sw),
        .threshold(threshold),
        .count(count),
        .ges(ges),
        .geu(geu),
        .gts(gts),
        .gtu(gtu),
        .les(les),
        .leu(leu),
        .lts(lts),
        .ltu(ltu),
        .max(max),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            count_sw = 1;
            thresh_sw = 0;
            threshold = 0;
            @(posedge clk);
            #1;
            count_sw = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();
            threshold = 32'h0;
            #1;

            #1;


            check_outputs(32'h0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Increment to 5, Threshold 3 (Unsigned GT)", test_num);
            reset_dut();
            thresh_sw = 0;
            repeat(5) @(posedge clk);
            threshold = 32'd3;
            #1;

            #1;


            check_outputs(32'd5, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Wrap around to Max (0 to FFFFFFFF)", test_num);
            reset_dut();
            thresh_sw = 1;
            @(posedge clk);
            threshold = 32'h0;
            #1;




            #1;





            check_outputs(32'hFFFFFFFF, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Signed Comparison (-2 vs -1)", test_num);
            reset_dut();
            thresh_sw = 1;
            repeat(2) @(posedge clk);
            threshold = 32'hFFFFFFFF;
            #1;



            #1;




            check_outputs(32'hFFFFFFFE, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Comparison (0 vs FFFFFFFF)", test_num);
            reset_dut();
            threshold = 32'hFFFFFFFF;
            #1;



            #1;




            check_outputs(32'h0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Equality Logic (10 == 10)", test_num);
            reset_dut();
            thresh_sw = 0;
            repeat(10) @(posedge clk);
            threshold = 32'd10;
            #1;

            #1;


            check_outputs(32'd10, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0);
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
        input [31:0] expected_count;
        input expected_ges;
        input expected_geu;
        input expected_gts;
        input expected_gtu;
        input expected_les;
        input expected_leu;
        input expected_lts;
        input expected_ltu;
        input expected_max;
        input expected_zero;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_ges === (expected_ges ^ ges ^ expected_ges) &&
                expected_geu === (expected_geu ^ geu ^ expected_geu) &&
                expected_gts === (expected_gts ^ gts ^ expected_gts) &&
                expected_gtu === (expected_gtu ^ gtu ^ expected_gtu) &&
                expected_les === (expected_les ^ les ^ expected_les) &&
                expected_leu === (expected_leu ^ leu ^ expected_leu) &&
                expected_lts === (expected_lts ^ lts ^ expected_lts) &&
                expected_ltu === (expected_ltu ^ ltu ^ expected_ltu) &&
                expected_max === (expected_max ^ max ^ expected_max) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: count=%h, ges=%b, geu=%b, gts=%b, gtu=%b, les=%b, leu=%b, lts=%b, ltu=%b, max=%b, zero=%b",
                         count, ges, geu, gts, gtu, les, leu, lts, ltu, max, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, ges=%b, geu=%b, gts=%b, gtu=%b, les=%b, leu=%b, lts=%b, ltu=%b, max=%b, zero=%b",
                         expected_count, expected_ges, expected_geu, expected_gts, expected_gtu, expected_les, expected_leu, expected_lts, expected_ltu, expected_max, expected_zero);
                $display("  Got:      count=%h, ges=%b, geu=%b, gts=%b, gtu=%b, les=%b, leu=%b, lts=%b, ltu=%b, max=%b, zero=%b",
                         count, ges, geu, gts, gtu, les, leu, lts, ltu, max, zero);
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
        $dumpvars(0,clk, count_sw, thresh_sw, threshold, count, ges, geu, gts, gtu, les, leu, lts, ltu, max, zero);
    end

endmodule
