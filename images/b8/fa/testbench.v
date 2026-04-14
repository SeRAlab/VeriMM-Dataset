`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg select;
    reg [31:0] z;
    wire [31:0] x;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .select(select),
        .z(z),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select LOW, z = 0xAAAAAAAA", test_num);
            select = 1'b0;
            z = 32'hAAAAAAAA;
            #1;

            check_outputs(32'h00000000, 32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select HIGH, z = 0xAAAAAAAA", test_num);
            select = 1'b1;
            z = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAAA, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select LOW, z = 0x55555555", test_num);
            select = 1'b0;
            z = 32'h55555555;
            #1;

            check_outputs(32'h00000000, 32'h55555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select HIGH, z = 0x55555555", test_num);
            select = 1'b1;
            z = 32'h55555555;
            #1;

            check_outputs(32'h55555555, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select LOW, z = 0xFFFFFFFF", test_num);
            select = 1'b0;
            z = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select HIGH, z = 0xFFFFFFFF", test_num);
            select = 1'b1;
            z = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF, 32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select LOW, z = 0x00000000", test_num);
            select = 1'b0;
            z = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select HIGH, z = 0x00000000", test_num);
            select = 1'b1;
            z = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select LOW, z = 0x12345678", test_num);
            select = 1'b0;
            z = 32'h12345678;
            #1;

            check_outputs(32'h00000000, 32'h12345678);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select HIGH, z = 0xDEADBEEF", test_num);
            select = 1'b1;
            z = 32'hDEADBEEF;
            #1;

            check_outputs(32'hDEADBEEF, 32'h00000000);
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
        input [31:0] expected_x;
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: x=%h, y=%h",
                         x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h, y=%h",
                         expected_x, expected_y);
                $display("  Got:      x=%h, y=%h",
                         x, y);
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
