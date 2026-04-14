`timescale 1ns/1ps

module wallace_tree_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [4:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wallace_tree_adder dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Small Values", test_num);
        a = 4'd1; b = 4'd1; c = 4'd1; d = 4'd1;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Incremental Sequence", test_num);
        a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Powers of Two", test_num);
        a = 4'd1; b = 4'd2; c = 4'd4; d = 4'd8;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Summing close to 31", test_num);
        a = 4'd7; b = 4'd8; c = 4'd7; d = 4'd8;
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum 5-bit sum (31)", test_num);
        a = 4'd15; b = 4'd10; c = 4'd5; d = 4'd1;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Truncation (Sum=32, Expected=0)", test_num);
        a = 4'd8; b = 4'd8; c = 4'd8; d = 4'd8;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Max Inputs Truncation (Sum=60, Expected=28)", test_num);
        a = 4'd15; b = 4'd15; c = 4'd15; d = 4'd15;
        #1;

        check_outputs(5'd28);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single active input", test_num);
        a = 4'd12; b = 4'd0; c = 4'd0; d = 4'd0;
        #1;

        check_outputs(5'd12);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating patterns", test_num);
        a = 4'b1010; b = 4'b0101; c = 4'b1010; d = 4'b0101;
        #1;

        check_outputs(5'd30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wallace_tree_adder Testbench");
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
        input [4:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
