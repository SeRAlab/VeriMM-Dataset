`timescale 1ns/1ps

module parallel_adder_tb;

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
    parallel_adder dut (
        .A(A),
        .B(B),
        .carry_in(carry_in),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Simple addition (2 + 3, cin=0)", test_num);
        A = 4'd2; B = 4'd3; carry_in = 1'b0;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Addition with carry-in (5 + 5, cin=1)", test_num);
        A = 4'd5; B = 4'd5; carry_in = 1'b1;
        #1;

        check_outputs(1'b0, 4'd11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Carry-out check (8 + 8, cin=0)", test_num);
        A = 4'd8; B = 4'd8; carry_in = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Maximum values (15 + 15, cin=1)", test_num);
        A = 4'hF; B = 4'hF; carry_in = 1'b1;
        #1;

        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Zero inputs", test_num);
        A = 4'd0; B = 4'd0; carry_in = 1'b0;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %03d: Sum equals 16 (15 + 1, cin=0)", test_num);
        A = 4'd15; B = 4'd1; carry_in = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %03d: Alternate bits (1010 + 0101, cin=0)", test_num);
        A = 4'b1010; B = 4'b0101; carry_in = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %03d: Ripple carry check (1111 + 0000, cin=1)", test_num);
        A = 4'b1111; B = 4'b0000; carry_in = 1'b1;
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %03d: Boundary check (0 + 15, cin=0)", test_num);
        A = 4'd0; B = 4'd15; carry_in = 1'b0;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %03d: Random logic check (7 + 6, cin=1)", test_num);
        A = 4'd7; B = 4'd6; carry_in = 1'b1;
        #1;

        check_outputs(1'b0, 4'd14);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_adder Testbench");
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
