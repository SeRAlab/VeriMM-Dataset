`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_1;
    reg [7:0] in_2;
    reg [7:0] in_3;
    reg [7:0] in_4;
    reg [1:0] select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_1(in_1),
        .in_2(in_2),
        .in_3(in_3),
        .in_4(in_4),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Select in_1 (00)", test_num);
            in_1 = 8'hAA;
            in_2 = 8'h55;
            in_3 = 8'h00;
            in_4 = 8'hFF;
            select = 2'b00;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Select in_2 (01)", test_num);
            in_1 = 8'hAA;
            in_2 = 8'h55;
            in_3 = 8'h00;
            in_4 = 8'hFF;
            select = 2'b01;
            #10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Select in_3 (10)", test_num);
            in_1 = 8'h12;
            in_2 = 8'h34;
            in_3 = 8'h56;
            in_4 = 8'h78;
            select = 2'b10;
            #10;
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Select in_4 (11)", test_num);
            in_1 = 8'h12;
            in_2 = 8'h34;
            in_3 = 8'h56;
            in_4 = 8'h78;
            select = 2'b11;
            #10;
            #1;

            check_outputs(8'h78);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: All inputs zero, select 00", test_num);
            in_1 = 8'h00;
            in_2 = 8'h00;
            in_3 = 8'h00;
            in_4 = 8'h00;
            select = 2'b00;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: All inputs max (FF), select 11", test_num);
            in_1 = 8'hFF;
            in_2 = 8'hFF;
            in_3 = 8'hFF;
            in_4 = 8'hFF;
            select = 2'b11;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Dynamic change check", test_num);
            in_1 = 8'hDE;
            in_2 = 8'hAD;
            in_3 = 8'hBE;
            in_4 = 8'hEF;
            select = 2'b01;
            #5;

            in_1 = 8'h00;
            #5;
            #1;

            check_outputs(8'hAD);
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
        input [7:0] expected_out;
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
