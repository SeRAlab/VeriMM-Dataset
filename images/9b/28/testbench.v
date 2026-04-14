`timescale 1ns/1ps

module binary_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [4:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_subtractor dut (
        .a(a),
        .b(b),
        .diff(diff)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=10, b=5 (Normal Subtraction)", test_num);
        a = 4'd10; b = 4'd5;
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=5, b=10 (Borrow Case)", test_num);
        a = 4'd5; b = 4'd10;
        #1;

        check_outputs(5'h1B);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=0, b=0 (Zero Case)", test_num);
        a = 4'd0; b = 4'd0;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=15, b=15 (Max Equals Case)", test_num);
        a = 4'd15; b = 4'd15;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=15, b=0 (Max a, Min b)", test_num);
        a = 4'd15; b = 4'd0;
        #1;

        check_outputs(5'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=0, b=15 (Min a, Max b)", test_num);
        a = 4'd0; b = 4'd15;
        #1;

        check_outputs(5'h11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=7, b=8 (Off-by-one Negative)", test_num);
        a = 4'd7; b = 4'd8;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=8, b=7 (Off-by-one Positive)", test_num);
        a = 4'd8; b = 4'd7;
        #1;

        check_outputs(5'h01);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=0, b=1 (Smallest Borrow)", test_num);
        a = 4'd0; b = 4'd1;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=1, b=0 (Smallest result)", test_num);
        a = 4'd1; b = 4'd0;
        #1;

        check_outputs(5'h01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_subtractor Testbench");
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
        input [4:0] expected_diff;
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
