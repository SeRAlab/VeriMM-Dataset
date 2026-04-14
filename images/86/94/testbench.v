`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .seg(seg)
    );
    task testcase001;

    begin
        test_num = 1;
        d = 8'd0;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        d = 8'd1;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        d = 8'd2;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        d = 8'd3;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        d = 8'd4;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        d = 8'd5;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        d = 8'd6;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        d = 8'd7;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        d = 8'd8;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        d = 8'd9;
        $display("Test Case %0d: Input d = %0d (Valid)", test_num, d);
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        d = 8'd10;
        $display("Test Case %0d: Input d = %0d (Unsupported, Default to 0)", test_num, d);
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        d = 8'd255;
        $display("Test Case %0d: Input d = %0d (Unsupported, Default to 0)", test_num, d);
        #1;

        check_outputs(7'h3f);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
