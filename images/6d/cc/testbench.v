`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] gray;
    wire [23:0] channels;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gray(gray),
        .channels(channels)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray scale value 0x00 (Black)", test_num);
            gray = 8'h00;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray scale value 0xFF (White)", test_num);
            gray = 8'hFF;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray scale value 0x55", test_num);
            gray = 8'h55;
            #1;

            check_outputs(24'h555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray scale value 0xAA", test_num);
            gray = 8'hAA;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray scale value 0x12", test_num);
            gray = 8'h12;
            #1;

            check_outputs(24'h121212);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray scale value 0x80 (Mid-gray)", test_num);
            gray = 8'h80;
            #1;

            check_outputs(24'h808080);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray scale value 0x3C", test_num);
            gray = 8'h3C;
            #1;

            check_outputs(24'h3C3C3C);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gray scale value 0xC3", test_num);
            gray = 8'hC3;
            #1;

            check_outputs(24'hC3C3C3);
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
        input [23:0] expected_channels;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_channels === (expected_channels ^ channels ^ expected_channels)) begin
                $display("PASS");
                $display("  Outputs: channels=%h",
                         channels);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channels=%h",
                         expected_channels);
                $display("  Got:      channels=%h",
                         channels);
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
