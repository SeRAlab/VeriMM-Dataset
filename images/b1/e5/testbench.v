`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din_a;
    reg [7:0] din_b;
    wire [7:0] dout_a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_a(din_a),
        .din_b(din_b),
        .dout_a(dout_a)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            din_a = 8'h00;
            din_b = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            din_a = 8'hFF;
            din_b = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (Complementary)", test_num);
            din_a = 8'hAA;
            din_b = 8'h55;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity AND", test_num);
            din_a = 8'hA5;
            din_b = 8'hA5;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper vs Lower Nibble", test_num);
            din_a = 8'hF0;
            din_b = 0'h0F;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Bitwise AND (1)", test_num);
            din_a = 8'hCC;
            din_b = 8'hAA;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Bitwise AND (2)", test_num);
            din_a = 8'h12;
            din_b = 8'h34;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clearing Single Bits", test_num);
            din_a = 8'hFF;
            din_b = 8'hFE;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit Masking", test_num);
            din_a = 8'h77;
            din_b = 8'h0F;
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Most Significant and Least Significant Bits", test_num);
            din_a = 8'h81;
            din_b = 8'hFF;
            #1;

            check_outputs(8'h81);
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
        input [7:0] expected_dout_a;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout_a === (expected_dout_a ^ dout_a ^ expected_dout_a)) begin
                $display("PASS");
                $display("  Outputs: dout_a=%h",
                         dout_a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout_a=%h",
                         expected_dout_a);
                $display("  Got:      dout_a=%h",
                         dout_a);
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
