`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data0;
    reg [15:0] data1;
    reg [15:0] data2;
    reg [15:0] data3;
    reg [1:0] selectinput;
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
        .selectinput(selectinput),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Selecting data0 (selectinput = 2'b00)", test_num);
            data0 = 16'hAAAA;
            data1 = 16'hBBBB;
            data2 = 16'hCCCC;
            data3 = 16'hDDDD;
            selectinput = 2'b00;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Selecting data1 (selectinput = 2'b01)", test_num);
            data0 = 16'h1234;
            data1 = 16'h5678;
            data2 = 16'h9ABC;
            data3 = 16'hDEF0;
            selectinput = 2'b01;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Selecting data2 (selectinput = 2'b10)", test_num);
            data0 = 16'hFFFF;
            data1 = 16'h0000;
            data2 = 16'hA5A5;
            data3 = 16'h5A5A;
            selectinput = 2'b10;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Selecting data3 (selectinput = 2'b11)", test_num);
            data0 = 16'h1111;
            data1 = 16'h2222;
            data2 = 16'h3333;
            data3 = 16'h4444;
            selectinput = 2'b11;
            #1;

            check_outputs(16'h4444);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary values select 2", test_num);
            data0 = 16'h0000;
            data1 = 16'h0000;
            data2 = 16'hFFFF;
            data3 = 16'h0000;
            selectinput = 2'b10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Undefined selectinput (default to data0)", test_num);
            data0 = 16'hCAFE;
            data1 = 16'hBABE;
            data2 = 16'hFACE;
            data3 = 16'hDEAD;
            selectinput = 2'bxx;
            #1;

            check_outputs(16'hCAFE);
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
