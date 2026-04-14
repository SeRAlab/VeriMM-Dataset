`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] analog_in;
    wire [7:0] digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .analog_in(analog_in),
        .digital_out(digital_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum input (0x0000)", test_num);
        analog_in = 16'h0000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum input (0xFFFF)", test_num);
        analog_in = 16'hFFFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-scale input (0x8000)", test_num);
        analog_in = 16'h8000;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Quarter-scale input (0x4000)", test_num);
        analog_in = 16'h4000;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Three-quarter scale input (0xC000)", test_num);
        analog_in = 16'hC000;
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary input (0xA520)", test_num);
        analog_in = 16'hA520;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Low range input (0x01FF)", test_num);
        analog_in = 16'h01FF;
        #1;

        check_outputs(8'h01);
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
        input [7:0] expected_digital_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_out === (expected_digital_out ^ digital_out ^ expected_digital_out)) begin
                $display("PASS");
                $display("  Outputs: digital_out=%h",
                         digital_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_out=%h",
                         expected_digital_out);
                $display("  Got:      digital_out=%h",
                         digital_out);
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
