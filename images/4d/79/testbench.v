`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] err_level;
    reg [7:0] error;
    wire [1:0] noise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .err_level(err_level),
        .error(error),
        .noise(noise)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: error < err_level (error=8'h0A, err_level=8'h14)", test_num);
            error = 8'h0A;
            err_level = 8'h14;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: error > err_level (error=8'h14, err_level=8'h0A)", test_num);
            error = 8'h14;
            err_level = 8'h0A;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: error == err_level (error=8'h0F, err_level=8'h0F)", test_num);
            error = 8'h0F;
            err_level = 8'h0F;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: error < err_level, lower bits 00 (error=8'h04, err_level=8'h08)", test_num);
            error = 8'h04;
            err_level = 8'h08;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: error < err_level, lower bits 11 (error=8'h03, err_level=8'h05)", test_num);
            error = 8'h03;
            err_level = 8'h05;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary - max error, zero level", test_num);
            error = 8'hFF;
            err_level = 8'h00;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary - zero error, max level", test_num);
            error = 8'h00;
            err_level = 8'hFF;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: error just below level (error=254, level=255)", test_num);
            error = 8'd254;
            err_level = 8'd255;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_noise;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_noise === (expected_noise ^ noise ^ expected_noise)) begin
                $display("PASS");
                $display("  Outputs: noise=%h",
                         noise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: noise=%h",
                         expected_noise);
                $display("  Got:      noise=%h",
                         noise);
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
