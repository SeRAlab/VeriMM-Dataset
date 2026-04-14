`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ReadData1;
    reg [31:0] ReadData2;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = 1;
        ReadData1 = 32'h0000_0000;
        ReadData2 = 32'h0000_0000;
        $display("Test Case %0d: Both zero", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ReadData1 = 32'hFFFF_FFFF;
        ReadData2 = 32'hFFFF_FFFF;
        $display("Test Case %0d: All ones", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ReadData1 = 32'hA5A5_1234;
        ReadData2 = 32'hA5A5_1234;
        $display("Test Case %0d: Identical mid-range values", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ReadData1 = 32'h0000_0000;
        ReadData2 = 32'h0000_0001;
        $display("Test Case %0d: LSB difference", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ReadData1 = 32'h0000_0000;
        ReadData2 = 32'h8000_0000;
        $display("Test Case %0d: MSB difference", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ReadData1 = 32'hAAAA_AAAA;
        ReadData2 = 32'h5555_5555;
        $display("Test Case %0d: Bitwise inverses", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ReadData1 = 32'h1234_5678;
        ReadData2 = 32'h1234_5E78;
        $display("Test Case %0d: Middle bit difference", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ReadData1 = 32'h0000_0000;
        ReadData2 = 32'h0000_CAFE;
        $display("Test Case %0d: Zero vs non-zero", test_num);
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
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Zero=%b",
                         Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Zero=%b",
                         expected_Zero);
                $display("  Got:      Zero=%b",
                         Zero);
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
