`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] iInput0;
    reg [15:0] iInput1;
    reg [15:0] iInput2;
    reg [15:0] iInput3;
    reg [1:0] iSelect;
    wire [15:0] oOutput;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iInput0(iInput0),
        .iInput1(iInput1),
        .iInput2(iInput2),
        .iInput3(iInput3),
        .iSelect(iSelect),
        .oOutput(oOutput)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 0", test_num);
        iInput0 = 16'hAAAA;
        iInput1 = 16'h5555;
        iInput2 = 16'h1234;
        iInput3 = 16'hFFFF;
        iSelect = 2'b00;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 1", test_num);
        iInput0 = 16'hAAAA;
        iInput1 = 16'h5555;
        iInput2 = 16'h1234;
        iInput3 = 16'hFFFF;
        iSelect = 2'b01;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 2", test_num);
        iInput0 = 16'hAAAA;
        iInput1 = 16'h5555;
        iInput2 = 16'h1234;
        iInput3 = 16'hFFFF;
        iSelect = 2'b10;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 3", test_num);
        iInput0 = 16'hAAAA;
        iInput1 = 16'h5555;
        iInput2 = 16'h1234;
        iInput3 = 16'hFFFF;
        iSelect = 2'b11;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Inputs Zero", test_num);
        iInput0 = 16'h0000;
        iInput1 = 16'h0000;
        iInput2 = 16'h0000;
        iInput3 = 16'h0000;
        iSelect = 2'b10;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Inputs One", test_num);
        iInput0 = 16'hFFFF;
        iInput1 = 16'hFFFF;
        iInput2 = 16'hFFFF;
        iInput3 = 16'hFFFF;
        iSelect = 2'b01;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking Bit Input 0", test_num);
        iInput0 = 16'h0001;
        iInput1 = 16'h0000;
        iInput2 = 16'h0000;
        iInput3 = 16'h0000;
        iSelect = 2'b00;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Changing Data While Selected", test_num);
        iSelect = 2'b11;
        iInput3 = 16'hBEEF;
        #5;
        iInput3 = 16'hDEAD;
        #1;

        check_outputs(16'hDEAD);
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
        input [15:0] expected_oOutput;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oOutput === (expected_oOutput ^ oOutput ^ expected_oOutput)) begin
                $display("PASS");
                $display("  Outputs: oOutput=%h",
                         oOutput);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oOutput=%h",
                         expected_oOutput);
                $display("  Got:      oOutput=%h",
                         oOutput);
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
