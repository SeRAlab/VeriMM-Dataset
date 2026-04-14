`timescale 1ns/1ps

module add_sub_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg sub;
    wire overflow;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_sub dut (
        .A(A),
        .B(B),
        .sub(sub),
        .overflow(overflow),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition 2 + 3", test_num);
        A = 4'd2; B = 4'd3; sub = 1'b0;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition -2 + -3", test_num);
        A = 4'hE; B = 4'hD; sub = 1'b0;
        #1;

        check_outputs(1'b0, 4'hB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Addition 4 + 5 (Overflow)", test_num);
        A = 4'h4; B = 4'h5; sub = 1'b0;
        #1;

        check_outputs(1'b1, 4'h9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Addition -5 + -6 (Overflow)", test_num);
        A = 4'hB; B = 4'hA; sub = 1'b0;
        #1;

        check_outputs(1'b1, 4'h5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Subtraction 5 - 2", test_num);
        A = 4'h5; B = 4'h2; sub = 1'b1;
        #1;

        check_outputs(1'b0, 4'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Subtraction 2 - 5", test_num);
        A = 4'h2; B = 4'h5; sub = 1'b1;
        #1;

        check_outputs(1'b0, 4'hD);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Subtraction 7 - (-2) (Overflow)", test_num);
        A = 4'h7; B = 4'hE; sub = 1'b1;
        #1;

        check_outputs(1'b1, 4'h9);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Subtraction -7 - 2 (Overflow)", test_num);
        A = 4'h9; B = 4'h2; sub = 1'b1;
        #1;

        check_outputs(1'b1, 4'h7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Addition 0 + 0", test_num);
        A = 4'h0; B = 4'h0; sub = 1'b0;
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Subtraction -8 - 0", test_num);
        A = 4'h8; B = 4'h0; sub = 1'b1;
        #1;

        check_outputs(1'b0, 4'h8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_sub Testbench");
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
        input expected_overflow;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, sum=%h",
                         overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, sum=%h",
                         expected_overflow, expected_sum);
                $display("  Got:      overflow=%b, sum=%h",
                         overflow, sum);
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
