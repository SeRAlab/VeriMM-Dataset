`timescale 1ns/1ps

module carry_skip_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg carry_in;
    wire carry_out;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_skip_adder dut (
        .A(A),
        .B(B),
        .carry_in(carry_in),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0000; B = 4'b0000; carry_in = 1'b0;
        $display("Test %0d: Adding zeros", test_num);
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b0101; B = 4'b0011; carry_in = 1'b0;
        $display("Test %0d: Basic addition (5 + 3 = 8)", test_num);
        #1;

        check_outputs(1'b0, 4'b1000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b1010; B = 4'b0101; carry_in = 1'b0;
        $display("Test %0d: All bits propagate (P=1111), carry_in=0", test_num);
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b1010; B = 4'b0101; carry_in = 1'b1;
        $display("Test %0d: Carry-Skip Activation (P=1111, carry_in=1)", test_num);

        #1;


        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b1111; B = 4'b0000; carry_in = 1'b1;
        $display("Test %0d: Maximum sum without carry-out overflow (15 + 0 + 1)", test_num);
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b1111; B = 4'b1111; carry_in = 1'b1;
        $display("Test %0d: All inputs logic high (15 + 15 + 1)", test_num);

        #1;


        check_outputs(1'b1, 4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b1000; B = 4'b1000; carry_in = 1'b0;
        $display("Test %0d: Internal carry generation, no skip (8 + 8)", test_num);
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b0111; B = 4'b0000; carry_in = 1'b1;
        $display("Test %0d: Ripple carry check (7 + 0 + 1)", test_num);
        #1;

        check_outputs(1'b0, 4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b1100; B = 4'b0011; carry_in = 1'b1;
        $display("Test %0d: Another Carry-Skip path (12 + 3 + 1)", test_num);
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'b1011; B = 4'b0100; carry_in = 1'b0;
        $display("Test %0d: Mixed bits (11 + 4 = 15)", test_num);
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_skip_adder Testbench");
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
        input expected_carry_out;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
