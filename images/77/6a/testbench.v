`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [15:0] to_display;
    wire [3:0] D1;
    wire [3:0] D2;
    wire [3:0] D3;
    wire [3:0] D4;
    wire [3:0] D5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .to_display(to_display),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable logic check (Inactive)", test_num);
            enable = 1'b0;
            to_display = 16'd12345;
            #1;

            check_outputs(4'hF, 4'hF, 4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Displaying zero", test_num);
            enable = 1'b1;
            to_display = 16'd0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single digit (9)", test_num);
            enable = 1'b1;
            to_display = 16'd9;
            #1;

            check_outputs(4'h9, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary value (10)", test_num);
            enable = 1'b1;
            to_display = 16'd10;
            #1;

            check_outputs(4'h0, 4'h1, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Triple digits (456)", test_num);
            enable = 1'b1;
            to_display = 16'd456;
            #1;

            check_outputs(4'h6, 4'h5, 4'h4, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 (4096)", test_num);
            enable = 1'b1;
            to_display = 16'd4096;
            #1;

            check_outputs(4'h6, 4'h9, 4'h0, 4'h4, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large value (54321)", test_num);
            enable = 1'b1;
            to_display = 16'd54321;
            #1;

            check_outputs(4'h1, 4'h2, 4'h3, 4'h4, 4'h5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max 16-bit value (65535)", test_num);
            enable = 1'b1;
            to_display = 16'hFFFF;
            #1;

            check_outputs(4'h5, 4'h3, 4'h5, 4'h5, 4'h6);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disable after activity", test_num);
            enable = 1'b0;
            to_display = 16'd9999;
            #1;

            check_outputs(4'hF, 4'hF, 4'hF, 4'hF, 4'hF);
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
        input [3:0] expected_D1;
        input [3:0] expected_D2;
        input [3:0] expected_D3;
        input [3:0] expected_D4;
        input [3:0] expected_D5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2) &&
                expected_D3 === (expected_D3 ^ D3 ^ expected_D3) &&
                expected_D4 === (expected_D4 ^ D4 ^ expected_D4) &&
                expected_D5 === (expected_D5 ^ D5 ^ expected_D5)) begin
                $display("PASS");
                $display("  Outputs: D1=%h, D2=%h, D3=%h, D4=%h, D5=%h",
                         D1, D2, D3, D4, D5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%h, D2=%h, D3=%h, D4=%h, D5=%h",
                         expected_D1, expected_D2, expected_D3, expected_D4, expected_D5);
                $display("  Got:      D1=%h, D2=%h, D3=%h, D4=%h, D5=%h",
                         D1, D2, D3, D4, D5);
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
