`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] res;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .res(res),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple subtraction (10 - 5)", test_num);
            a = 32'd10;
            b = 32'd5;
            #1;

            check_outputs(32'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Equality check (Result zero flag)", test_num);
            a = 32'hABCD_1234;
            b = 32'hABCD_1234;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero inputs (0 - 0)", test_num);
            a = 32'd0;
            b = 32'd0;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small minus large (Negative result)", test_num);
            a = 32'd5;
            b = 32'd10;

            #1;


            check_outputs(32'hFFFF_FFFB, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max value minus 1", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'hFFFF_FFFE, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow (0 - 1)", test_num);
            a = 32'h0000_0000;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtracting large constant", test_num);
            a = 32'h8000_0000;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'h7FFF_FFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Two negative numbers (2's complement)", test_num);

            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large difference", test_num);
            a = 32'h7FFF_FFFF;
            b = 32'h8000_0000;

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern check", test_num);
            a = 32'h1234_5678;
            b = 32'h0234_5670;
            #1;

            check_outputs(32'h1000_0008, 1'b0);
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
        input [31:0] expected_res;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: res=%h, zero=%b",
                         res, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h, zero=%b",
                         expected_res, expected_zero);
                $display("  Got:      res=%h, zero=%b",
                         res, zero);
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
