`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] color_in;
    reg disp_on;
    wire [2:0] color_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .color_in(color_in),
        .disp_on(disp_on),
        .color_out(color_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Display disabled, input color 3'b101", test_num);
        disp_on = 1'b0;
        color_in = 3'b101;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Display enabled, input color 3'b101", test_num);
        disp_on = 1'b1;
        color_in = 3'b101;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Display enabled, input color 3'b010", test_num);
        disp_on = 1'b1;
        color_in = 3'b010;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Display disabled, input color 3'b111", test_num);
        disp_on = 1'b0;
        color_in = 3'b111;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Display enabled, input color 3'b111 (White)", test_num);
        disp_on = 1'b1;
        color_in = 3'b111;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Display enabled, input color 3'b000 (Black)", test_num);
        disp_on = 1'b1;
        color_in = 3'b000;
        #1;

        check_outputs(3'b000);
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
        input [2:0] expected_color_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_color_out === (expected_color_out ^ color_out ^ expected_color_out)) begin
                $display("PASS");
                $display("  Outputs: color_out=%h",
                         color_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color_out=%h",
                         expected_color_out);
                $display("  Got:      color_out=%h",
                         color_out);
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
