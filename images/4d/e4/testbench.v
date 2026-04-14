`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg ctrl;
    wire [15:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .res(res)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 0 * 0", test_num);
            ctrl = 0;
            a = 8'd0;
            b = 8'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 255 * 255 (Max Unsigned)", test_num);
            ctrl = 0;
            a = 8'hFF;
            b = 8'hFF;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 12 * 12", test_num);
            ctrl = 0;
            a = 8'd12;
            b = 8'd12;
            #1;

            check_outputs(16'h0090);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed 5 * 3 (Positive * Positive)", test_num);
            ctrl = 1;
            a = 8'd5;
            b = 8'd3;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -1 * 1 (Negative * Positive)", test_num);
            ctrl = 1;
            a = 8'hFF;
            b = 8'h01;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -1 * -1 (Negative * Negative)", test_num);
            ctrl = 1;
            a = 8'hFF;
            b = 8'hFF;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -128 * 2 (Min Signed * Positive)", test_num);
            ctrl = 1;
            a = 8'h80;
            b = 8'h02;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -128 * -1 (Min Signed * -1)", test_num);
            ctrl = 1;
            a = 8'h80;
            b = 8'hFF;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed 127 * 127 (Max Signed * Max Signed)", test_num);
            ctrl = 1;
            a = 8'h7F;
            b = 8'h7F;
            #1;

            check_outputs(16'h3F01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -128 * -128 (Min Signed * Min Signed)", test_num);
            ctrl = 1;
            a = 8'h80;
            b = 8'h80;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify ctrl switch (Unsigned vs Signed for same inputs)", test_num);
            a = 8'hFF;
            b = 8'hFF;

            $display("  Subtest: ctrl=0 (Unsigned)");
            ctrl = 0;
            #1;

            check_outputs(16'hFE01);

            $display("  Subtest: ctrl=1 (Signed)");
            ctrl = 1;
            #1;

            check_outputs(16'h0001);
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
        input [15:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
