`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] line;
    wire [3:0] pixels;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .line(line),
        .pixels(pixels)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        line = 3'd0;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        line = 3'd1;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        line = 3'd2;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        line = 3'd3;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        line = 3'd4;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        line = 3'd5;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        line = 3'd6;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        line = 3'd7;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_pixels;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixels === (expected_pixels ^ pixels ^ expected_pixels)) begin
                $display("PASS");
                $display("  Outputs: pixels=%h",
                         pixels);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixels=%h",
                         expected_pixels);
                $display("  Got:      pixels=%h",
                         pixels);
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
