`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;
    wire [7:0] out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Zero Input", test_num);
            in = 8'h00;

            #1;


            check_outputs(8'h01, 8'h02, 8'h03, 8'h04);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Small Value", test_num);
            in = 8'h0A;
            #1;

            check_outputs(8'h0B, 8'h0C, 8'h0D, 8'h0E);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Mid-range Value", test_num);
            in = 8'h7F;
            #1;

            check_outputs(8'h80, 8'h81, 8'h82, 8'h83);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: High Value (Near Overflow)", test_num);
            in = 8'hFD;

            #1;


            check_outputs(8'hFE, 8'hFF, 8'h00, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Maximum Value (Overflow handling)", test_num);
            in = 8'hFF;

            #1;


            check_outputs(8'h00, 8'h01, 8'h02, 8'h03);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Pattern Input", test_num);
            in = 8'hAA;
            #1;

            check_outputs(8'hAB, 8'hAC, 8'hAD, 8'hAE);
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
        input [7:0] expected_out1;
        input [7:0] expected_out2;
        input [7:0] expected_out3;
        input [7:0] expected_out4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
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
