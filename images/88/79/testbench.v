`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg Ci;
    reg PI;
    reg cnt;
    reg ld;
    reg reset;
    wire Co;
    wire [3:0] PO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .Ci(Ci),
        .PI(PI),
        .cnt(cnt),
        .ld(ld),
        .reset(reset),
        .Co(Co),
        .PO(PO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            reset = 1;
            Ci = 0;
            PI = 0;
            cnt = 0;
            ld = 0;
            @(posedge CLK);
            #1 reset = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load PI=1", test_num);
            reset_dut();
            PI = 1;
            ld = 1;
            @(posedge CLK);
            #1;
            ld = 0;
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Increment", test_num);
            reset_dut();
            cnt = 1;
            Ci = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Increments", test_num);
            reset_dut();
            cnt = 1;
            Ci = 1;
            @(posedge CLK);
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Carry-In Inhibition", test_num);
            reset_dut();
            cnt = 1;
            Ci = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count Enable Inhibition", test_num);
            reset_dut();
            cnt = 0;
            Ci = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Value and Co", test_num);
            reset_dut();
            cnt = 1;
            Ci = 1;
            repeat(15) @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Wrap Around (15 to 0)", test_num);
            reset_dut();
            cnt = 1;
            Ci = 1;
            repeat(16) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Priority", test_num);
            reset_dut();
            PI = 1;
            ld = 1;
            cnt = 1;
            Ci = 1;
            @(posedge CLK);
            #1;


            ld = 0;

            @(posedge CLK);
            #1;
            PI = 0;
            ld = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Co Gating logic", test_num);
            reset_dut();
            cnt = 1;
            Ci = 1;
            repeat(15) @(posedge CLK);
            #1;
            Ci = 0;
            #1;
            #1;

            check_outputs(1'b0, 4'd15);
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
        input expected_Co;
        input [3:0] expected_PO;
        begin
            if (expected_Co === (expected_Co ^ Co ^ expected_Co) &&
                expected_PO === (expected_PO ^ PO ^ expected_PO)) begin
                $display("PASS");
                $display("  Outputs: Co=%b, PO=%h",
                         Co, PO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Co=%b, PO=%h",
                         expected_Co, expected_PO);
                $display("  Got:      Co=%b, PO=%h",
                         Co, PO);
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
        $dumpvars(0,CLK, Ci, PI, cnt, ld, reset, Co, PO);
    end

endmodule
