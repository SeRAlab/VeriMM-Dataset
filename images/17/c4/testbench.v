`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [1:0] carry;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0; B = 4'd0; C = 4'd0;
        $display("Test %0d: All Zeros (0+0+0)", test_num);
        #1;

        check_outputs(2'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd1; B = 4'd2; C = 4'd3;
        $display("Test %0d: Small values (1+2+3=6)", test_num);
        #1;

        check_outputs(2'd0, 4'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd5; B = 4'd5; C = 4'd5;
        $display("Test %0d: Sum is 15 (5+5+5=15)", test_num);
        #1;

        check_outputs(2'd0, 4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd8; B = 4'd8; C = 4'd0;
        $display("Test %0d: Sum is 16 (8+8+0=16)", test_num);
        #1;

        check_outputs(2'd1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd10; B = 4'd10; C = 4'd10;
        $display("Test %0d: Sum is 30 (10+10+10=30)", test_num);
        #1;

        check_outputs(2'd1, 4'd14);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd15; B = 4'd15; C = 4'd0;
        $display("Test %0d: Sum is 30 (15+15+0=30)", test_num);
        #1;

        check_outputs(2'd1, 4'd14);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd15; B = 4'd15; C = 4'd1;
        $display("Test %0d: Sum is 31 (15+15+1=31)", test_num);
        #1;

        check_outputs(2'd1, 4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd15; B = 4'd15; C = 4'd2;
        $display("Test %0d: Sum is 32 (15+15+2=32)", test_num);
        #1;

        check_outputs(2'd2, 4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'd10; B = 4'd15; C = 4'd10;
        $display("Test %0d: Sum is 35 (10+15+10=35)", test_num);
        #1;

        check_outputs(2'd2, 4'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'd15; B = 4'd15; C = 4'd15;
        $display("Test %0d: Max Sum (15+15+15=45)", test_num);
        #1;

        check_outputs(2'd2, 4'd13);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_save_adder Testbench");
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
        input [1:0] expected_carry;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%h, sum=%h",
                         carry, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%h, sum=%h",
                         expected_carry, expected_sum);
                $display("  Got:      carry=%h, sum=%h",
                         carry, sum);
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
