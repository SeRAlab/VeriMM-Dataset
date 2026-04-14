`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ExtSel;
    reg [15:0] datain;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ExtSel(ExtSel),
        .datain(datain),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: ExtSel=0, datain[15]=0", test_num);
        ExtSel = 1'b0;
        datain = 16'h0001;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: ExtSel=0, datain[15]=1", test_num);
        ExtSel = 1'b0;
        datain = 16'h8005;
        #1;

        check_outputs(32'h00008005);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: ExtSel=1, datain[15]=0", test_num);
        ExtSel = 1'b1;
        datain = 16'h7ABC;
        #1;

        check_outputs(32'h00007ABC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: ExtSel=1, datain[15]=1", test_num);
        ExtSel = 1'b1;
        datain = 16'h8ABC;
        #1;

        check_outputs(32'hFFFF8ABC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: ExtSel=0, datain=FFFF", test_num);
        ExtSel = 1'b0;
        datain = 16'hFFFF;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: ExtSel=1, datain=FFFF", test_num);
        ExtSel = 1'b1;
        datain = 16'hFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: ExtSel=1, datain=0000", test_num);
        ExtSel = 1'b1;
        datain = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: ExtSel=0, datain=5555", test_num);
        ExtSel = 1'b0;
        datain = 16'h5555;
        #1;

        check_outputs(32'h00005555);
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
