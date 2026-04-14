`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    reg B2;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    reg enable;
    reg reset;
    wire X;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .B2(B2),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .enable(enable),
        .reset(reset),
        .X(X),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            reset = 1;
            A1 = 0; A2 = 0; A3 = 0; B1 = 0; B2 = 0;
            VPWR = 1; VPB = 1; VGND = 0; VNB = 0;
            repeat(2) @(posedge enable);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: All inputs HIGH", test_num);
            A1 = 1; A2 = 1; A3 = 1; B1 = 1; B2 = 1;
            @(posedge enable);
            #2 #1;
 check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: All inputs LOW", test_num);
            A1 = 0; A2 = 0; A3 = 0; B1 = 0; B2 = 0;
            @(posedge enable);
            #2 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: One input HIGH (A1)", test_num);
            A1 = 1; A2 = 0; A3 = 0; B1 = 0; B2 = 0;
            @(posedge enable);
            #2 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Two inputs HIGH (A1, B1)", test_num);
            A1 = 1; A2 = 0; A3 = 0; B1 = 1; B2 = 0;
            @(posedge enable);
            #2 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Four inputs HIGH", test_num);
            A1 = 1; A2 = 1; A3 = 1; B1 = 1; B2 = 0;
            @(posedge enable);
            #2 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Reset active with all inputs HIGH", test_num);
            reset = 1;
            A1 = 1; A2 = 1; A3 = 1; B1 = 1; B2 = 1;
            @(posedge enable);
            #2 #1;
 check_outputs(0, 0);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %03d: Transition from all 1s to one 0", test_num);
            A1 = 1; A2 = 1; A3 = 1; B1 = 1; B2 = 1;
            @(posedge enable);
            #1;
            A3 = 0;
            @(posedge enable);
            #2 #1;
 check_outputs(0, 1);
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
        input expected_X;
        input expected_overflow;
        begin
            if (expected_X === (expected_X ^ X ^ expected_X) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: X=%b, overflow=%b",
                         X, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b, overflow=%b",
                         expected_X, expected_overflow);
                $display("  Got:      X=%b, overflow=%b",
                         X, overflow);
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
        $dumpvars(0,A1, A2, A3, B1, B2, VGND, VNB, VPB, VPWR, enable, reset, X, overflow);
    end

endmodule
