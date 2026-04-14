`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DEFSLAVEDATASEL;
    reg HCLK;
    reg HRESETN;
    wire DEFSLAVEDATAREADY;
    wire HRESP_DEFAULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DEFSLAVEDATASEL(DEFSLAVEDATASEL),
        .HCLK(HCLK),
        .HRESETN(HRESETN),
        .DEFSLAVEDATAREADY(DEFSLAVEDATAREADY),
        .HRESP_DEFAULT(HRESP_DEFAULT)
    );

    // Clock generation (10ns period)
    initial begin
        HCLK = 0;
        forever #5 HCLK = ~HCLK;
    end

        task reset_dut;

        begin
            HRESETN = 0;
            DEFSLAVEDATASEL = 0;
            @(posedge HCLK);
            #1;
            HRESETN = 1;
            @(posedge HCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Idle with no selection", test_num);
            reset_dut();
            DEFSLAVEDATASEL = 0;
            repeat(2) @(posedge HCLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Error Response Cycle 1 (Wait State)", test_num);
            reset_dut();
            DEFSLAVEDATASEL = 1;
            @(posedge HCLK);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Error Response Cycle 2 (HRESPEXTEND)", test_num);
            reset_dut();
            DEFSLAVEDATASEL = 1;
            @(posedge HCLK);
            DEFSLAVEDATASEL = 0;
            @(posedge HCLK);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Return to IDLE after transfer", test_num);
            reset_dut();
            DEFSLAVEDATASEL = 1;
            @(posedge HCLK);
            DEFSLAVEDATASEL = 0;
            @(posedge HCLK);
            @(posedge HCLK);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Back-to-back Error Responses", test_num);
            reset_dut();

            DEFSLAVEDATASEL = 1;
            @(posedge HCLK);


            @(posedge HCLK);
            DEFSLAVEDATASEL = 1;
            @(posedge HCLK);
            @(posedge HCLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_DEFSLAVEDATAREADY;
        input expected_HRESP_DEFAULT;
        begin
            if (expected_DEFSLAVEDATAREADY === (expected_DEFSLAVEDATAREADY ^ DEFSLAVEDATAREADY ^ expected_DEFSLAVEDATAREADY) &&
                expected_HRESP_DEFAULT === (expected_HRESP_DEFAULT ^ HRESP_DEFAULT ^ expected_HRESP_DEFAULT)) begin
                $display("PASS");
                $display("  Outputs: DEFSLAVEDATAREADY=%b, HRESP_DEFAULT=%b",
                         DEFSLAVEDATAREADY, HRESP_DEFAULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DEFSLAVEDATAREADY=%b, HRESP_DEFAULT=%b",
                         expected_DEFSLAVEDATAREADY, expected_HRESP_DEFAULT);
                $display("  Got:      DEFSLAVEDATAREADY=%b, HRESP_DEFAULT=%b",
                         DEFSLAVEDATAREADY, HRESP_DEFAULT);
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
        $dumpvars(0,DEFSLAVEDATASEL, HCLK, HRESETN, DEFSLAVEDATAREADY, HRESP_DEFAULT);
    end

endmodule
