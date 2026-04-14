`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [3:0] aluc;
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
            test_num = 1;
            a = 32'd15;
            b = 32'd25;
            aluc = 4'b0000;
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'd100;
            b = 32'd40;
            aluc = 4'b0001;
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'hF0F0FFFF;
            b = 32'h0F0F5555;
            aluc = 4'b0010;
            #1;

            check_outputs(32'h00005555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hAAAA0000;
            b = 32'h00005555;
            aluc = 4'b0011;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'hFFFFFFFF;
            b = 32'h12345678;
            aluc = 4'b0100;
            #1;

            check_outputs(~32'h12345678);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'h00000001;
            b = 32'd8;
            aluc = 4'b0101;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h80000000;
            b = 32'd4;
            aluc = 4'b0110;
            #1;

            check_outputs(32'h08000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'h0;
            b = 32'h0000ABCD;
            aluc = 4'b0111;
            #1;

            check_outputs(32'hABCD0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'd50;
            b = 32'd50;
            aluc = 4'b1111;
            #1;

            check_outputs(32'd100);
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
