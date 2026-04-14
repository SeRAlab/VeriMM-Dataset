`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk40;
    reg full_rst_trig;
    reg idelay_rst_trig;
    wire dcm_rst;
    wire idelay_rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk40(clk40),
        .full_rst_trig(full_rst_trig),
        .idelay_rst_trig(idelay_rst_trig),
        .dcm_rst(dcm_rst),
        .idelay_rst(idelay_rst)
    );

    // Clock generation (10ns period)
    initial begin
        clk40 = 0;
        forever #5 clk40 = ~clk40;
    end

        task reset_dut;

        begin
            full_rst_trig = 1'b0;
            idelay_rst_trig = 1'b0;
            repeat(5) @(posedge clk40);
            $display("DUT Reset: Triggers cleared, waiting for stability...");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Idle State Check", test_num);
            reset_dut();

            repeat(2) @(posedge clk40);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: IDELAY Reset Trigger", test_num);
            reset_dut();

            @(negedge clk40);
            idelay_rst_trig = 1'b1;


            repeat(2) @(posedge clk40);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Full Reset Trigger", test_num);
            reset_dut();

            @(negedge clk40);
            full_rst_trig = 1'b1;


            repeat(2) @(posedge clk40);




            if (dcm_rst === 1'b1) begin
                $display("PASS: full_rst_trig correctly asserted dcm_rst");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: full_rst_trig failed to assert dcm_rst");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Simultaneous Triggers", test_num);
            reset_dut();

            @(negedge clk40);
            full_rst_trig = 1'b1;
            idelay_rst_trig = 1'b1;

            repeat(2) @(posedge clk40);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Trigger De-assertion Check", test_num);
            reset_dut();

            @(negedge clk40);
            full_rst_trig = 1'b1;
            idelay_rst_trig = 1'b1;
            repeat(2) @(posedge clk40);


            @(negedge clk40);
            full_rst_trig = 1'b0;
            idelay_rst_trig = 1'b0;


            repeat(5) @(posedge clk40);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_dcm_rst;
        input expected_idelay_rst;
        begin
            if (expected_dcm_rst === (expected_dcm_rst ^ dcm_rst ^ expected_dcm_rst) &&
                expected_idelay_rst === (expected_idelay_rst ^ idelay_rst ^ expected_idelay_rst)) begin
                $display("PASS");
                $display("  Outputs: dcm_rst=%b, idelay_rst=%b",
                         dcm_rst, idelay_rst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dcm_rst=%b, idelay_rst=%b",
                         expected_dcm_rst, expected_idelay_rst);
                $display("  Got:      dcm_rst=%b, idelay_rst=%b",
                         dcm_rst, idelay_rst);
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
        $dumpvars(0,clk40, full_rst_trig, idelay_rst_trig, dcm_rst, idelay_rst);
    end

endmodule
