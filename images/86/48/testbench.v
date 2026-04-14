`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary_number;
    wire [15:0] decimal_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_number(binary_number),
        .decimal_number(decimal_number)
    );
    task testcase001;

    begin
        test_num = 1;
        binary_number = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        binary_number = 8'h01;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        binary_number = 8'h7F;
        #1;

        check_outputs(16'h007F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        binary_number = 8'hFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        binary_number = 8'h80;
        #1;

        check_outputs(16'hFF80);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        binary_number = 8'hF6;
        #1;

        check_outputs(16'hFFF6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        binary_number = 8'h40;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        binary_number = 8'hC0;
        #1;

        check_outputs(16'hFFC0);
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
        input [15:0] expected_decimal_number;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decimal_number === (expected_decimal_number ^ decimal_number ^ expected_decimal_number)) begin
                $display("PASS");
                $display("  Outputs: decimal_number=%h",
                         decimal_number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decimal_number=%h",
                         expected_decimal_number);
                $display("  Got:      decimal_number=%h",
                         decimal_number);
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
