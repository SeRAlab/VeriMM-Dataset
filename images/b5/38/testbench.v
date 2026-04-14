`timescale 1ns/1ps

module subtractor_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire borrow_out;
    wire [15:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_16bit dut (
        .a(a),
        .b(b),
        .borrow_out(borrow_out),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Basic subtraction (a > b)");
            a = 16'h0064;
            b = 16'h0028;
            #1;

            check_outputs(1'b0, 16'h003C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Subtraction resulting in zero");
            a = 16'hFFFF;
            b = 16'hFFFF;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Subtraction requiring borrow (a < b)");
            a = 16'h0005;
            b = 16'h000A;
            #1;

            check_outputs(1'b1, 16'hFFFB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Borrow from 0 (0 - 1)");
            a = 16'h0000;
            b = 16'h0001;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Large values without borrow");
            a = 16'hC000;
            b = 16'h4000;
            #1;

            check_outputs(1'b0, 16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Max value minus zero");
            a = 16'hFFFF;
            b = 16'h0000;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Boundary borrow");
            a = 16'h8000;
            b = 16'h8001;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Complex hex subtraction");
            a = 16'hABCD;
            b = 16'h1234;
            #1;

            check_outputs(1'b0, 16'h9999);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: Minimum possible a - maximum possible b");
            a = 16'h0000;
            b = 16'hFFFF;
            #1;

            check_outputs(1'b1, 16'h0001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: Small difference with borrow");
            a = 16'h1000;
            b = 16'h1001;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_16bit Testbench");
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
        input expected_borrow_out;
        input [15:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, diff=%h",
                         borrow_out, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, diff=%h",
                         expected_borrow_out, expected_diff);
                $display("  Got:      borrow_out=%b, diff=%h",
                         borrow_out, diff);
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
