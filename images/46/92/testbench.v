`timescale 1ns/1ps

module subtractor_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_32bit dut (
        .a(a),
        .b(b),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Subtraction (Positive Result)", test_num);
            a = 32'h0000_000A;
            b = 32'h0000_0003;
            #1;

            check_outputs(32'h0000_0007);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Resulting in Zero", test_num);
            a = 32'h1234_5678;
            b = 32'h1234_5678;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction with Borrow Across 8-bit Boundaries", test_num);

            a = 32'h0001_0000;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction with Underflow (Negative Wrap)", test_num);
            a = 32'h0000_0000;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtracting Zero", test_num);
            a = 32'hABCD_EF12;
            b = 32'h0000_0000;
            #1;

            check_outputs(32'hABCD_EF12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Value Subtraction", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction with Multiple Borrows", test_num);
            a = 32'hF000_0000;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'hEFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Numbers Subtraction", test_num);
            a = 32'hFEDC_BA98;
            b = 32'h7654_3210;
            #1;

            check_outputs(32'h8888_8888);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_32bit Testbench");
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
        input [31:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
