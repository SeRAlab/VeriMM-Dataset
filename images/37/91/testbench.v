`timescale 1ns/1ps

module dwt_haar_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    wire [15:0] a0;
    wire [15:0] a1;
    wire [15:0] d0;
    wire [15:0] d1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_haar dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .a0(a0),
        .a1(a1),
        .d0(d0),
        .d1(d1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: DC Signal Input", test_num);
        x0 = 16'd20; x1 = 16'd20; x2 = 16'd40; x3 = 16'd40;
        #1;

        check_outputs(16'd20, 16'd40, 16'd0, 16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Positive Step Change", test_num);
        x0 = 16'd40; x1 = 16'd20; x2 = 16'd80; x3 = 16'd60;
        #1;

        check_outputs(16'd30, 16'd70, 16'd10, 16'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Negative Difference Result", test_num);
        x0 = 16'd20; x1 = 16'd40; x2 = 16'd60; x3 = 16'd80;
        #1;

        check_outputs(16'd30, 16'd70, 16'hFFF6, 16'hFFF6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: High Frequency Alternating Input", test_num);
        x0 = 16'd100; x1 = 16'hFF9C; x2 = 16'd200; x3 = 16'hFF38;
        #1;

        check_outputs(16'd0, 16'd0, 16'h0064, 16'h00C8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: All Zeros", test_num);
        x0 = 16'd0; x1 = 16'd0; x2 = 16'd0; x3 = 16'd0;
        #1;

        check_outputs(16'd0, 16'd0, 16'd0, 16'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Large Value/Maximum Range", test_num);
        x0 = 16'd30000; x1 = 16'd0; x2 = 16'd0; x3 = 16'd30000;
        #1;

        check_outputs(16'h3A98, 16'h3A98, 16'h3A98, 16'hC568);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_haar Testbench");
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
        input [15:0] expected_a0;
        input [15:0] expected_a1;
        input [15:0] expected_d0;
        input [15:0] expected_d1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a0 === (expected_a0 ^ a0 ^ expected_a0) &&
                expected_a1 === (expected_a1 ^ a1 ^ expected_a1) &&
                expected_d0 === (expected_d0 ^ d0 ^ expected_d0) &&
                expected_d1 === (expected_d1 ^ d1 ^ expected_d1)) begin
                $display("PASS");
                $display("  Outputs: a0=%h, a1=%h, d0=%h, d1=%h",
                         a0, a1, d0, d1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a0=%h, a1=%h, d0=%h, d1=%h",
                         expected_a0, expected_a1, expected_d0, expected_d1);
                $display("  Got:      a0=%h, a1=%h, d0=%h, d1=%h",
                         a0, a1, d0, d1);
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
