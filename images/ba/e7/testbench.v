`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [15:0] cos;
    wire [15:0] sin;
    wire [15:0] tan;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .cos(cos),
        .sin(sin),
        .tan(tan)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Angle 0 degrees", test_num);
        in = 16'h0000;
        #1;

        check_outputs(16'h4000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Angle 45 degrees", test_num);
        in = 16'h2000;
        #1;

        check_outputs(16'h2D41, 16'h2D41, 16'h4000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Angle -45 degrees", test_num);
        in = 16'hE000;
        #1;

        check_outputs(16'h2D41, 16'hD2BF, 16'hC000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Angle 90 degrees", test_num);
        in = 16'h4000;
        #1;

        check_outputs(16'h0000, 16'h4000, 16'h7FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Angle -90 degrees", test_num);
        in = 16'hC000;
        #1;

        check_outputs(16'h0000, 16'hC000, 16'h8001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small positive angle", test_num);
        in = 16'h0100;
        #1;

        check_outputs(16'h3FF3, 16'h0192, 16'h0193);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sine zero edge case", test_num);
        in = 16'h0000;
        #1;

        check_outputs(16'h4000, 16'h0000, 16'h0000);
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
        input [15:0] expected_cos;
        input [15:0] expected_sin;
        input [15:0] expected_tan;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cos === (expected_cos ^ cos ^ expected_cos) &&
                expected_sin === (expected_sin ^ sin ^ expected_sin) &&
                expected_tan === (expected_tan ^ tan ^ expected_tan)) begin
                $display("PASS");
                $display("  Outputs: cos=%h, sin=%h, tan=%h",
                         cos, sin, tan);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cos=%h, sin=%h, tan=%h",
                         expected_cos, expected_sin, expected_tan);
                $display("  Got:      cos=%h, sin=%h, tan=%h",
                         cos, sin, tan);
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
