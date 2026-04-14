`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire carry_out;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .A(A),
        .B(B),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero Addition (0 + 0)", test_num);
        A = 8'h00;
        B = 8'h00;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple Addition (10 + 5)", test_num);
        A = 8'd10;
        B = 8'd5;
        #1;

        check_outputs(1'b0, 8'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Boundary No Carry (255 + 0)", test_num);
        A = 8'hFF;
        B = 8'h00;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Minimum Carry Out (255 + 1)", test_num);
        A = 8'hFF;
        B = 8'h01;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Maximum Carry Out (255 + 255)", test_num);
        A = 8'hFF;
        B = 8'hFF;
        #1;

        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Mid-range Addition (128 + 128)", test_num);
        A = 8'h80;
        B = 8'h80;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Alternating Bits (0xAA + 0x55)", test_num);
        A = 8'hAA;
        B = 8'h55;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Random Values (200 + 100)", test_num);
        A = 8'd200;
        B = 8'd100;

        #1;


        check_outputs(1'b1, 8'h2C);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Carry into MSB (127 + 1)", test_num);
        A = 8'h7F;
        B = 8'h01;
        #1;

        check_outputs(1'b0, 8'h80);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Small addition (1 + 1)", test_num);
        A = 8'h01;
        B = 8'h01;
        #1;

        check_outputs(1'b0, 8'h02);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [7:0] expected_sum;
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
