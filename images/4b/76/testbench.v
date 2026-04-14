`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d;
    reg en;
    wire v;
    wire y0;
    wire y1;
    wire y2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .en(en),
        .v(v),
        .y0(y0),
        .y1(y1),
        .y2(y2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Disabled State (en=0, d=8'hFF)", test_num);
            en = 0;
            d = 8'hFF;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input d[0] Active (en=1, d=8'h01)", test_num);
            en = 1;
            d = 8'h01;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input d[3] Active (en=1, d=8'h08)", test_num);
            en = 1;
            d = 8'h08;
            #1;

            check_outputs(1, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input d[4] Active (en=1, d=8'h10)", test_num);
            en = 1;
            d = 8'h10;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input d[7] Active (en=1, d=8'h80)", test_num);
            en = 1;
            d = 8'h80;
            #1;

            check_outputs(0, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (en=1, d=8'h81)", test_num);
            en = 1;
            d = 8'h81;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (en=1, d=8'h44)", test_num);
            en = 1;
            d = 8'h44;
            #1;

            check_outputs(1, 0, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (en=1, d=8'h30)", test_num);
            en = 1;
            d = 8'h30;
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No Inputs Active (en=1, d=8'h00)", test_num);
            en = 1;
            d = 8'h00;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lower Four Active (en=1, d=8'h0F)", test_num);
            en = 1;
            d = 8'h0F;
            #1;

            check_outputs(1, 1, 1, 0);
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
        input expected_v;
        input expected_y0;
        input expected_y1;
        input expected_y2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v === (expected_v ^ v ^ expected_v) &&
                expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2)) begin
                $display("PASS");
                $display("  Outputs: v=%b, y0=%b, y1=%b, y2=%b",
                         v, y0, y1, y2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v=%b, y0=%b, y1=%b, y2=%b",
                         expected_v, expected_y0, expected_y1, expected_y2);
                $display("  Got:      v=%b, y0=%b, y1=%b, y2=%b",
                         v, y0, y1, y2);
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
