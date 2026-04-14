`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire carry_out;
    wire [4:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .A(A),
        .B(B),
        .clk(clk),
        .carry_out(carry_out),
        .sum_out(sum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'd0;
            B = 4'd0;
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Addition (5 + 3)", test_num);
            A = 4'd5;
            B = 4'd3;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 5'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Carry-out Boundary (8 + 8)", test_num);
            A = 4'd8;
            B = 4'd8;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 5'd16);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values (15 + 15)", test_num);
            A = 4'd15;
            B = 4'd15;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 5'd30);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Addition (0 + 0)", test_num);
            A = 4'd0;
            B = 4'd0;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 5'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max sum without carry (10 + 5)", test_num);
            A = 4'd10;
            B = 4'd5;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 5'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [4:0] expected_sum_out;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum_out=%h",
                         carry_out, sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum_out=%h",
                         expected_carry_out, expected_sum_out);
                $display("  Got:      carry_out=%b, sum_out=%h",
                         carry_out, sum_out);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, clk, carry_out, sum_out);
    end

endmodule
