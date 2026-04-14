`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .w(w)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 16'd0;
        b = 16'd0;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 16'd1234;
        b = 16'd1;
        #1;

        check_outputs(32'd1234);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 16'd12;
        b = 16'd11;
        #1;

        check_outputs(32'd132);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 16'd256;
        b = 16'd512;
        #1;

        check_outputs(32'd131072);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 16'hFFFF;
        b = 16'hFFFF;
        #1;

        check_outputs(32'hFFFE0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 16'd97;
        b = 16'd101;
        #1;

        check_outputs(32'd9797);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 16'hABCD;
        b = 16'd0;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 16'h8000;
        b = 16'd2;
        #1;

        check_outputs(32'd65536);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 16'd500;
        b = 16'd600;
        #1;

        check_outputs(32'd300000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 16'd181;
        b = 16'd181;
        #1;

        check_outputs(32'd32761);
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
        input [31:0] expected_w;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w === (expected_w ^ w ^ expected_w)) begin
                $display("PASS");
                $display("  Outputs: w=%h",
                         w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h",
                         expected_w);
                $display("  Got:      w=%h",
                         w);
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
