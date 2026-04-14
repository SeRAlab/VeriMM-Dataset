`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a_m;
    reg [4:0] tmp_cnt;
    wire [15:0] a_m_shift;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_m(a_m),
        .tmp_cnt(tmp_cnt),
        .a_m_shift(a_m_shift)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 0", test_num);
            a_m = 16'hABCD;
            tmp_cnt = 5'd0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 1 (Multiply by 2)", test_num);
            a_m = 16'h0001;
            tmp_cnt = 5'd1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 4", test_num);
            a_m = 16'h1234;
            tmp_cnt = 5'd4;
            #1;

            check_outputs(16'h2340);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 8", test_num);
            a_m = 16'h00FF;
            tmp_cnt = 5'd8;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 15 (MSB check)", test_num);
            a_m = 16'h0001;
            tmp_cnt = 5'd15;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 16 (Full overflow)", test_num);
            a_m = 16'hFFFF;
            tmp_cnt = 5'd16;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 31 (Max range)", test_num);
            a_m = 16'hFFFF;
            tmp_cnt = 5'd31;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones, shift by 4", test_num);
            a_m = 16'hFFFF;
            tmp_cnt = 5'd4;
            #1;

            check_outputs(16'hFFF0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift zero input", test_num);
            a_m = 16'h0000;
            tmp_cnt = 5'd10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex bit pattern", test_num);
            a_m = 16'hA5A5;
            tmp_cnt = 5'd2;
            #1;

            check_outputs(16'h9694);
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
        input [15:0] expected_a_m_shift;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_m_shift === (expected_a_m_shift ^ a_m_shift ^ expected_a_m_shift)) begin
                $display("PASS");
                $display("  Outputs: a_m_shift=%h",
                         a_m_shift);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_m_shift=%h",
                         expected_a_m_shift);
                $display("  Got:      a_m_shift=%h",
                         a_m_shift);
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
