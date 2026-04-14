`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] t;
    wire [24:0] out_eq3;
    wire [24:0] out_nand3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .t(t),
        .out_eq3(out_eq3),
        .out_nand3(out_nand3)
    );
    task run_test;

        input [25:0] t_val;
        reg [24:0] e_eq;
        reg [24:0] e_nand;
        integer i;
        begin
            t = t_val;

            for (i = 0; i < 25; i = i + 1) begin
                e_eq[i] = (t[i] == t[i+1]);
            end




            e_nand[0] = 1'bx;
            for (i = 1; i < 25; i = i + 1) begin
                e_nand[i] = ~(t[i] & t[i-1]);
            end

            test_num = test_num + 1;
            $display("Test case %0d: Input t = 26'h%h", test_num, t);
            #1;

            check_outputs(e_eq, e_nand);
        end
        endtask

    task testcase001;

        begin
            run_test(26'h0000000);
        end
        endtask

    task testcase002;

        begin
            run_test(26'h3FFFFFF);
        end
        endtask

    task testcase003;

        begin
            run_test(26'h2AAAAAA);
        end
        endtask

    task testcase004;

        begin
            run_test(26'h1555555);
        end
        endtask

    task testcase005;

        begin
            run_test(26'h0000003);
        end
        endtask

    task testcase006;

        begin
            run_test(26'h3000000);
        end
        endtask

    task testcase007;

        begin
            run_test(26'h1234567);
        end
        endtask

    task testcase008;

        begin
            run_test(26'h3C3C3C3);
        end
        endtask

    task testcase009;

        begin
            run_test(26'h0810204);
        end
        endtask

    task testcase010;

        begin
            run_test(26'h2F0F0F0);
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
        input [24:0] expected_out_eq3;
        input [24:0] expected_out_nand3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_eq3 === (expected_out_eq3 ^ out_eq3 ^ expected_out_eq3) &&
                expected_out_nand3 === (expected_out_nand3 ^ out_nand3 ^ expected_out_nand3)) begin
                $display("PASS");
                $display("  Outputs: out_eq3=%h, out_nand3=%h",
                         out_eq3, out_nand3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_eq3=%h, out_nand3=%h",
                         expected_out_eq3, expected_out_nand3);
                $display("  Got:      out_eq3=%h, out_nand3=%h",
                         out_eq3, out_nand3);
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
