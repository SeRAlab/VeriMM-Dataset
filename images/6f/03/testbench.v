`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data0;
    reg [15:0] data1;
    reg [15:0] data2;
    reg [15:0] data3;
    reg [15:0] data4;
    reg [15:0] data5;
    reg [15:0] data6;
    reg [15:0] data7;
    reg [2:0] selectInput;
    wire [15:0] out;

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
        .data4(data4),
        .data5(data5),
        .data6(data6),
        .data7(data7),
        .selectInput(selectInput),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            data0 = 16'hAAAA; data1 = 16'h0000; data2 = 16'h0000; data3 = 16'h0000;
            data4 = 16'h0000; data5 = 16'h0000; data6 = 16'h0000; data7 = 16'h0000;
            selectInput = 3'd0;
            #10;
            $display("Test Case %0d: Selecting Data0", test_num);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data0 = 16'h0000; data1 = 16'h5555; data2 = 16'h0000; data3 = 16'h0000;
            data4 = 16'h0000; data5 = 16'h0000; data6 = 16'h0000; data7 = 16'h0000;
            selectInput = 3'd1;
            #10;
            $display("Test Case %0d: Selecting Data1", test_num);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data2 = 16'h1234;
            selectInput = 3'd2;
            #10;
            $display("Test Case %0d: Selecting Data2", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data3 = 16'hBEEF;
            selectInput = 3'd3;
            #10;
            $display("Test Case %0d: Selecting Data3", test_num);
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data4 = 16'hCAFE;
            selectInput = 3'd4;
            #10;
            $display("Test Case %0d: Selecting Data4", test_num);
            #1;

            check_outputs(16'hCAFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data5 = 16'h00FF;
            selectInput = 3'd5;
            #10;
            $display("Test Case %0d: Selecting Data5", test_num);
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data6 = 16'hFF00;
            selectInput = 3'd6;
            #10;
            $display("Test Case %0d: Selecting Data6", test_num);
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data7 = 16'hABCD;
            selectInput = 3'd7;
            #10;
            $display("Test Case %0d: Selecting Data7", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data0 = 16'h0000; data1 = 16'h0000; data2 = 16'h0000; data3 = 16'h0000;
            data4 = 16'h0000; data5 = 16'h0000; data6 = 16'h0000; data7 = 16'h0000;
            selectInput = 3'd4;
            #10;
            $display("Test Case %0d: All Inputs Zero", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data0 = 16'hFFFF; data1 = 16'hFFFF; data2 = 16'hFFFF; data3 = 16'hFFFF;
            data4 = 16'hFFFF; data5 = 16'hFFFF; data6 = 16'hFFFF; data7 = 16'hFFFF;
            selectInput = 3'd7;
            #10;
            $display("Test Case %0d: All Inputs One", test_num);
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
