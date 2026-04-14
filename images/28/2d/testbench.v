`timescale 1ns/1ps

module wallace_tree_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [7:0] sum;

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
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Maximum Values", test_num);
        a = 4'd15; b = 4'd15; c = 4'd15; d = 4'd15;
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Powers of 2", test_num);
        a = 4'd1; b = 4'd2; c = 4'd4; d = 4'd8;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Alternating Bit Patterns", test_num);
        a = 4'b1010; b = 4'b0101; c = 4'b1010; d = 4'b0101;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Single Input Active", test_num);
        a = 4'd0; b = 4'd15; c = 4'd0; d = 4'd0;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: All Ones", test_num);
        a = 4'd1; b = 4'd1; c = 4'd1; d = 4'd1;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Mid-range Values", test_num);
        a = 4'd8; b = 4'd8; c = 4'd8; d = 4'd8;
        #1;

        check_outputs(8'd32);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Prime Numbers", test_num);
        a = 4'd7; b = 4'd11; c = 4'd13; d = 4'd2;
        #1;

        check_outputs(8'd33);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Mixed Distribution", test_num);
        a = 4'd14; b = 4'd3; c = 4'd12; d = 4'd6;
        #1;

        check_outputs(8'd35);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Large Mixed Values", test_num);
        a = 4'd15; b = 4'd14; c = 4'd13; d = 4'd12;
        #1;

        check_outputs(8'd54);
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
        input [7:0] expected_sum;
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
