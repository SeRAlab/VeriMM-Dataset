`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] n;
    wire [31:0] q;
    wire [3:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .n(n),
        .q(q),
        .r(r)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 0", test_num);
        n = 32'd0;
        #1;

        check_outputs(32'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 7", test_num);
        n = 32'd7;
        #1;

        check_outputs(32'd0, 4'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 10", test_num);
        n = 32'd10;
        #1;

        check_outputs(32'd1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 11", test_num);
        n = 32'd11;
        #1;

        check_outputs(32'd1, 4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 150", test_num);
        n = 32'd150;
        #1;

        check_outputs(32'd15, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 1023", test_num);
        n = 32'd1023;
        #1;

        check_outputs(32'd102, 4'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 32'hFFFFFFFF", test_num);
        n = 32'hFFFFFFFF;
        #1;

        check_outputs(32'd429496729, 4'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 99", test_num);
        n = 32'd99;
        #1;

        check_outputs(32'd9, 4'd9);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 123456", test_num);
        n = 32'd123456;
        #1;

        check_outputs(32'd12345, 4'd6);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 65535", test_num);
        n = 32'd65535;
        #1;

        check_outputs(32'd6553, 4'd5);
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
        input [31:0] expected_q;
        input [3:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: q=%h, r=%h",
                         q, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, r=%h",
                         expected_q, expected_r);
                $display("  Got:      q=%h, r=%h",
                         q, r);
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
