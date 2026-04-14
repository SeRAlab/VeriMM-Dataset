`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire [2:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .led(led)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=0, b=0 (Equality)", test_num);
        a = 2'd0; b = 2'd0;

        #1;


        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=3, b=3 (Equality)", test_num);
        a = 2'd3; b = 2'd3;

        #1;


        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=1, b=0 (A > B)", test_num);
        a = 2'd1; b = 2'd0;

        #1;


        check_outputs(3'b011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=3, b=1 (A > B)", test_num);
        a = 2'd3; b = 2'd1;

        #1;


        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=0, b=2 (B > A)", test_num);
        a = 2'd0; b = 2'd2;

        #1;


        check_outputs(3'b101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=2, b=3 (B > A)", test_num);
        a = 2'd2; b = 2'd3;

        #1;


        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=3, b=0 (Max vs Min)", test_num);
        a = 2'd3; b = 2'd0;

        #1;


        check_outputs(3'b011);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=0, b=3 (Min vs Max)", test_num);
        a = 2'd0; b = 2'd3;

        #1;


        check_outputs(3'b101);
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
        input [2:0] expected_led;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
