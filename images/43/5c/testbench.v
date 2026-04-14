`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] s;
    wire [3:0] s1;
    wire [7:0] sFim;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .s(s),
        .s1(s1),
        .sFim(sFim)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            a = 4'b0000;
            b = 4'b0000;

            #1;


            check_outputs(4'h0, 4'h0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones", test_num);
            a = 4'b1111;
            b = 4'b1111;

            #1;


            check_outputs(4'hF, 4'hF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complementary bits (A and 5)", test_num);
            a = 4'b1010;
            b = 4'b0101;

            #1;


            check_outputs(4'hF, 4'h0, 8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Partially overlapping bits", test_num);
            a = 4'b1100;
            b = 4'b1010;

            #1;


            check_outputs(4'hE, 4'h8, 8'h8E);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit set", test_num);
            a = 4'b0001;
            b = 4'b1000;

            #1;


            check_outputs(4'h9, 4'h0, 8'h09);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subset relationship", test_num);
            a = 4'b0111;
            b = 4'b0010;

            #1;


            check_outputs(4'h7, 4'h2, 8'h27);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random nibbles", test_num);
            a = 4'b1011;
            b = 4'b1101;

            #1;


            check_outputs(4'hF, 4'h9, 8'h9F);
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
        input [3:0] expected_s;
        input [3:0] expected_s1;
        input [7:0] expected_sFim;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s) &&
                expected_s1 === (expected_s1 ^ s1 ^ expected_s1) &&
                expected_sFim === (expected_sFim ^ sFim ^ expected_sFim)) begin
                $display("PASS");
                $display("  Outputs: s=%h, s1=%h, sFim=%h",
                         s, s1, sFim);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h, s1=%h, sFim=%h",
                         expected_s, expected_s1, expected_sFim);
                $display("  Got:      s=%h, s1=%h, sFim=%h",
                         s, s1, sFim);
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
