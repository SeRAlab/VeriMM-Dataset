`timescale 1ns/1ps

module adder_with_carry_tb;

    // Testbench signals (sequential circuit)
    reg carry_in;
    reg clk;
    reg [7:0] data1;
    reg [7:0] data2;
    reg reset;
    reg start;
    wire carry_out;
    wire done;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_with_carry dut (
        .carry_in(carry_in),
        .clk(clk),
        .data1(data1),
        .data2(data2),
        .reset(reset),
        .start(start),
        .carry_out(carry_out),
        .done(done),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start = 0;
        data1 = 0;
        data2 = 0;
        carry_in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic addition (no carry)", test_num);
        reset_dut();
        data1 = 8'h05;
        data2 = 8'h0A;
        carry_in = 1'b0;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done == 1'b1);
        #1;

        check_outputs(1'b0, 1'b1, 8'h0F);
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with carry_in", test_num);
        reset_dut();
        data1 = 8'h05;
        data2 = 8'h0A;
        carry_in = 1'b1;
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done == 1'b1);
        #1;

        check_outputs(1'b0, 1'b1, 8'h10);
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition resulting in maximum 8-bit value", test_num);
        reset_dut();
        data1 = 8'h80;
        data2 = 8'h7F;
        carry_in = 1'b0;
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done == 1'b1);
        #1;

        check_outputs(1'b0, 1'b1, 8'hFF);
        @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple overflow (carry_out set)", test_num);
        reset_dut();
        data1 = 8'hFF;
        data2 = 8'h01;
        carry_in = 1'b0;
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done == 1'b1);
        #1;

        check_outputs(1'b1, 1'b1, 8'h00);
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum values with carry_in and carry_out", test_num);
        reset_dut();
        data1 = 8'hFF;
        data2 = 8'hFF;
        carry_in = 1'b1;
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done == 1'b1);
        #1;

        check_outputs(1'b1, 1'b1, 8'hFF);
        @(posedge clk);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero addition", test_num);
        reset_dut();
        data1 = 8'h00;
        data2 = 8'h00;
        carry_in = 1'b0;
        start = 1;
        @(posedge clk);
        start = 0;
        wait(done == 1'b1);
        #1;

        check_outputs(1'b0, 1'b1, 8'h00);
        @(posedge clk);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_with_carry Testbench");
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
        input expected_done;
        input [7:0] expected_sum;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, done=%b, sum=%h",
                         carry_out, done, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, done=%b, sum=%h",
                         expected_carry_out, expected_done, expected_sum);
                $display("  Got:      carry_out=%b, done=%b, sum=%h",
                         carry_out, done, sum);
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
        $dumpvars(0,carry_in, clk, data1, data2, reset, start, carry_out, done, sum);
    end

endmodule
