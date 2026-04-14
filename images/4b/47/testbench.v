`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] mod;
    reg [2:0] rm;
    reg [2:0] sovr_pr;
    wire [3:0] base;
    wire [3:0] index;
    wire [1:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mod(mod),
        .rm(rm),
        .sovr_pr(sovr_pr),
        .base(base),
        .index(index),
        .seg(seg)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: mod=00, rm=000 (BX+SI, default DS)", test_num);
            mod = 2'b00; rm = 3'b000; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd3, 4'd6, 2'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: mod=00, rm=001 (BX+DI, default DS)", test_num);
            mod = 2'b00; rm = 3'b001; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd3, 4'd7, 2'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: mod=01, rm=010 (BP+SI, default SS)", test_num);
            mod = 2'b01; rm = 3'b010; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd5, 4'd6, 2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: mod=10, rm=011 (BP+DI, default SS)", test_num);
            mod = 2'b10; rm = 3'b011; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd5, 4'd7, 2'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: mod=00, rm=100 (SI only, default DS)", test_num);
            mod = 2'b00; rm = 3'b100; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd6, 4'hf, 2'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: mod=01, rm=101 (DI only, default DS)", test_num);
            mod = 2'b01; rm = 3'b101; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd7, 4'hf, 2'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: mod=00, rm=110 (Direct Address / displacement only)", test_num);
            mod = 2'b00; rm = 3'b110; sovr_pr = 3'b100;
            #1;

            check_outputs(4'hf, 4'hf, 2'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: mod=10, rm=110 (BP only, default SS)", test_num);
            mod = 2'b10; rm = 3'b110; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd5, 4'hf, 2'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: mod=01, rm=111 (BX only, default DS)", test_num);
            mod = 2'b01; rm = 3'b111; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd3, 4'hf, 2'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: mod=00, rm=000, Override ES", test_num);
            mod = 2'b00; rm = 3'b000; sovr_pr = 3'b000;
            #1;

            check_outputs(4'd3, 4'd6, 2'd0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: mod=01, rm=010, Override CS", test_num);
            mod = 2'b01; rm = 3'b010; sovr_pr = 3'b001;
            #1;

            check_outputs(4'd5, 4'd6, 2'd1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: mod=11, rm=000 (Register mode - AX)", test_num);
            mod = 2'b11; rm = 3'b000; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd0, 4'hf, 2'd0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test %0d: mod=11, rm=011 (Register mode - BX)", test_num);
            mod = 2'b11; rm = 3'b011; sovr_pr = 3'b100;
            #1;

            check_outputs(4'd3, 4'hf, 2'd0);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [3:0] expected_base;
        input [3:0] expected_index;
        input [1:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_base === (expected_base ^ base ^ expected_base) &&
                expected_index === (expected_index ^ index ^ expected_index) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: base=%h, index=%h, seg=%h",
                         base, index, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: base=%h, index=%h, seg=%h",
                         expected_base, expected_index, expected_seg);
                $display("  Got:      base=%h, index=%h, seg=%h",
                         base, index, seg);
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
