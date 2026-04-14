`timescale 1ns/1ps

module adder_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst_n;
    wire carry_out;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_8bit dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .carry_out(carry_out),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        a = 0;
        b = 0;
        @(posedge clk);
        #1;
        rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Basic Addition (15 + 10)", test_num);
        reset_dut();
        a = 8'd15;
        b = 8'd10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 8'd25);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Addition with Carry-Out (200 + 100)", test_num);
        reset_dut();
        a = 8'd200;
        b = 8'd100;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Maximum Values (255 + 255)", test_num);
        reset_dut();
        a = 8'hFF;
        b = 8'hFF;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Adding Zeros", test_num);
        reset_dut();
        a = 8'd0;
        b = 8'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Boundary Sum 255 (128 + 127)", test_num);
        reset_dut();
        a = 8'd128;
        b = 8'd127;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Reset Behavior Check", test_num);
        reset_dut();
        rst_n = 0;
        a = 8'hAA;
        b = 8'h55;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, clk, rst_n, carry_out, sum);
    end

endmodule
