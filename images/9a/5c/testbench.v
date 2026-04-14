`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dataa;
    reg [31:0] datab;
    wire [10:0] display;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataa(dataa),
        .datab(datab),
        .display(display),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            dataa = 32'h0;
            datab = 32'h0;


            #1;



            check_outputs(11'h000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DataA lower bits only", test_num);
            dataa = 32'h00000007;
            datab = 32'h00000000;


            #1;



            check_outputs(11'h700, 32'h00000007);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DataB lower bits only", test_num);
            dataa = 32'h00000000;
            datab = 32'h000000FF;


            #1;



            check_outputs(11'h0FF, 32'h000000FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed bits check", test_num);
            dataa = 32'hAAAAAAA5;
            datab = 32'h55555512;


            #1;



            check_outputs(11'h512, 32'hFFFFFFF7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Result Overflow/Large Values", test_num);
            dataa = 32'hFFFFFFFF;
            datab = 32'h00000001;


            #1;



            check_outputs(11'h701, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Upper bits isolation", test_num);

            dataa = 32'hFFFFFFF8;
            datab = 32'hFFFF0000;


            #1;



            check_outputs(11'h000, 32'hFFFEFFFF);
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
        input [10:0] expected_display;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_display === (expected_display ^ display ^ expected_display) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: display=%h, result=%h",
                         display, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h, result=%h",
                         expected_display, expected_result);
                $display("  Got:      display=%h, result=%h",
                         display, result);
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
