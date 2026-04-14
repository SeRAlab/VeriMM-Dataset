`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Y(Y)
    );

        task reset_dut;

        begin
            VPWR = 1;
            VGND = 0;
            VPB = 1;
            VNB = 0;
            A = 0;

            repeat(5) @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in five 1s (Expected Y=1)", test_num);
            reset_dut();
            @(posedge clk);
            A = 1;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in five 0s (Expected Y=0)", test_num);
            reset_dut();
            @(posedge clk);
            A = 0;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in mixed sequence 10101 (Expected Y=X)", test_num);
            reset_dut();
            @(posedge clk) A = 1;
            @(posedge clk) A = 0;
            @(posedge clk) A = 1;
            @(posedge clk) A = 0;
            @(posedge clk) A = 1;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shifting in 11110 (Expected Y=X)", test_num);
            reset_dut();
            @(posedge clk) A = 1;
            @(posedge clk) A = 1;
            @(posedge clk) A = 1;
            @(posedge clk) A = 1;
            @(posedge clk) A = 0;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power Supply Down (Expected Y=X)", test_num);
            reset_dut();
            VPWR = 0;
            #20;
            #1;

            check_outputs(1'bx);
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
        input expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
        $dumpvars(0,A, VGND, VNB, VPB, VPWR, Y);
    end

endmodule
