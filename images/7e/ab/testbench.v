`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] power_in;
    wire [7:0] power_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .power_in(power_in),
        .power_out(power_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable high, input 0xFF", test_num);
        enable = 1'b1;
        power_in = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable high, input 0x00", test_num);
        enable = 1'b1;
        power_in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable high, input 0x5A", test_num);
        enable = 1'b1;
        power_in = 8'h5A;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable low, input 0xFF", test_num);
        enable = 1'b0;
        power_in = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable low, input 0x55", test_num);
        enable = 1'b0;
        power_in = 8'h55;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable low, input 0x00", test_num);
        enable = 1'b0;
        power_in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable high, input 0xAA", test_num);
        enable = 1'b1;
        power_in = 8'hAA;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Transition Enable from high to low", test_num);
        enable = 1'b1;
        power_in = 8'h12;
        #5;
        enable = 1'b0;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_power_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_power_out === (expected_power_out ^ power_out ^ expected_power_out)) begin
                $display("PASS");
                $display("  Outputs: power_out=%h",
                         power_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power_out=%h",
                         expected_power_out);
                $display("  Got:      power_out=%h",
                         power_out);
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
