`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [7:0] data;
    wire [7:0] resistance;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data(data),
        .resistance(resistance)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Ctrl High, Data 0x55", test_num);
            ctrl = 1'b1;
            data = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Ctrl High, Data 0xAA", test_num);
            ctrl = 1'b1;
            data = 8'hAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Ctrl Low, Data 0xFF", test_num);
            ctrl = 1'b0;
            data = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Ctrl Low, Data 0x00", test_num);
            ctrl = 1'b0;
            data = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Ctrl High, Data 0xFF", test_num);
            ctrl = 1'b1;
            data = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Ctrl High, Data 0x00", test_num);
            ctrl = 1'b1;
            data = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Ctrl High, Walking Bit Pattern", test_num);
            ctrl = 1'b1;
            data = 8'h01;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Ctrl High, Inverse Walking Bit", test_num);
            ctrl = 1'b1;
            data = 8'h80;
            #1;

            check_outputs(8'h80);
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
        input [7:0] expected_resistance;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resistance === (expected_resistance ^ resistance ^ expected_resistance)) begin
                $display("PASS");
                $display("  Outputs: resistance=%h",
                         resistance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resistance=%h",
                         expected_resistance);
                $display("  Got:      resistance=%h",
                         resistance);
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
