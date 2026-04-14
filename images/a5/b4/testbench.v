`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] iData;
    wire [2:0] oData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iData(iData),
        .oData(oData)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input bit 0 (8'b0000_0001)", test_num);
        iData = 8'b0000_0001;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input bit 1 (8'b0000_0010)", test_num);
        iData = 8'b0000_0010;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input bit 2 (8'b0000_0100)", test_num);
        iData = 8'b0000_0100;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input bit 3 (8'b0000_1000)", test_num);
        iData = 8'b0000_1000;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input bit 4 (8'b0001_0000)", test_num);
        iData = 8'b0001_0000;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input bit 5 (8'b0010_0000)", test_num);
        iData = 8'b0010_0000;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input bit 6 (8'b0100_0000)", test_num);
        iData = 8'b0100_0000;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input bit 7 (8'b1000_0000)", test_num);
        iData = 8'b1000_0000;
        #1;

        check_outputs(3'b111);
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
        input [2:0] expected_oData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oData === (expected_oData ^ oData ^ expected_oData)) begin
                $display("PASS");
                $display("  Outputs: oData=%h",
                         oData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oData=%h",
                         expected_oData);
                $display("  Got:      oData=%h",
                         oData);
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
