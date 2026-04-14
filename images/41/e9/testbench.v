`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [4:0] aluc;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .aluc(aluc),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition", test_num);
            a = 32'd100;
            b = 32'd250;
            aluc = ADD;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction", test_num);
            a = 32'd500;
            b = 32'd150;
            aluc = SUB;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            a = 32'hAAAA_FFFF;
            b = 32'h5555_FFFF;
            aluc = AND;
            #1;

            check_outputs(32'h0000_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            a = 32'hF0F0_0000;
            b = 32'h0F0F_FFFF;
            aluc = OR;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLL (Shift Left Logical)", test_num);
            a = 32'd4;
            b = 32'h0000_0001;
            aluc = SLL;
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SRL (Shift Right Logical)", test_num);
            a = 32'd8;
            b = 32'h0000_FF00;
            aluc = SRL;
            #1;

            check_outputs(32'h0000_00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SRA (Arithmetic) Positive", test_num);
            a = 32'd2;
            b = 32'h0000_000C;
            aluc = SRA;
            #1;

            check_outputs(32'h0000_0003);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SRA (Arithmetic) Negative", test_num);
            a = 32'd4;
            b = 32'hF000_0000;
            aluc = SRA;
            #1;

            check_outputs(32'hFF00_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Negative)", test_num);
            a = 32'd10;
            b = -32'd5;
            aluc = ADD;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Negative Result)", test_num);
            a = 32'd10;
            b = 32'd20;
            aluc = SUB;
            #1;

            check_outputs(-32'd10);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
