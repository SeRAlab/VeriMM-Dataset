`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg enable;
    reg [1:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .enable(enable),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Enable HIGH (Output should be 0)");
            test_num = test_num + 1;
            enable = 1'b1;
            data0 = 1'b1; data1 = 1'b1; data2 = 1'b1; data3 = 1'b1;
            sel = 2'b00;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enable HIGH, change select (Output should stay 0)");
            test_num = test_num + 1;
            enable = 1'b1;
            data0 = 1'b1; data1 = 1'b1; data2 = 1'b1; data3 = 1'b1;
            sel = 2'b11;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable LOW, Select Data0 (Data0=1)");
            test_num = test_num + 1;
            enable = 1'b0;
            data0 = 4'b0001; data1 = 4'b0000; data2 = 4'b0000; data3 = 4'b0000;
            sel = 2'b00;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable LOW, Select Data0 (Data0=0)");
            test_num = test_num + 1;
            enable = 1'b0;
            data0 = 4'b0000; data1 = 4'b1111; data2 = 4'b1111; data3 = 4'b1111;
            sel = 2'b00;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable LOW, Select Data1 (Data1=1)");
            test_num = test_num + 1;
            enable = 1'b0;
            data0 = 4'b0000; data1 = 4'b0001; data2 = 4'b0000; data3 = 4'b0000;
            sel = 2'b01;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable LOW, Select Data1 (Data1=0)");
            test_num = test_num + 1;
            enable = 1'b0;
            data0 = 4'b1111; data1 = 4'b0000; data2 = 4'b1111; data3 = 4'b1111;
            sel = 2'b01;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Enable LOW, Select Data2 (Data2=1)");
            test_num = test_num + 1;
            enable = 1'b0;
            data0 = 4'b0000; data1 = 4'b0000; data2 = 4'b0001; data3 = 4'b0000;
            sel = 2'b10;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enable LOW, Select Data2 (Data2=0)");
            test_num = test_num + 1;
            enable = 1'b0;
            data0 = 4'b1111; data1 = 4'b1111; data2 = 4'b0000; data3 = 4'b1111;
            sel = 2'b10;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Enable LOW, Select Data3 (Data3=1)");
            test_num = test_num + 1;
            enable = 1'b0;
            data0 = 4'b0000; data1 = 4'b0000; data2 = 4'b0000; data3 = 4'b0001;
            sel = 2'b11;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Enable LOW, Select Data3 (Data3=0)");
            test_num = test_num + 1;
            enable = 1'b0;
            data0 = 4'b1111; data1 = 4'b1111; data2 = 4'b1111; data3 = 4'b0000;
            sel = 2'b11;
            #10;
            #1;

            check_outputs(1'b0);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
