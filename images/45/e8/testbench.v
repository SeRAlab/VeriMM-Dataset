`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data1;
    reg [7:0] data2;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1(data1),
        .data2(data2),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: 0 + 0", test_num);
            data1 = 8'd0;
            data2 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: 10 + 15", test_num);
            data1 = 8'd10;
            data2 = 8'd15;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: 255 + 0", test_num);
            data1 = 8'hFF;
            data2 = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: 128 + 127", test_num);
            data1 = 8'd128;
            data2 = 8'd127;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: 255 + 1 (Overflow)", test_num);
            data1 = 8'd255;
            data2 = 8'd1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: 255 + 2 (Overflow)", test_num);
            data1 = 8'd255;
            data2 = 8'd2;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: 128 + 128 (Overflow)", test_num);
            data1 = 8'd128;
            data2 = 8'd128;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: 0xAA + 0x55", test_num);
            data1 = 8'hAA;
            data2 = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: 0x0F + 0xF0", test_num);
            data1 = 8'h0F;
            data2 = 8'hF0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: 255 + 255 (Max Overflow)", test_num);
            data1 = 8'd255;
            data2 = 8'd255;
            #1;

            check_outputs(8'd254);
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
        input [7:0] expected_result;
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
