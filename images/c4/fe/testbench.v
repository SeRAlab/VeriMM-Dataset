`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg rst;
    wire carry_out;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
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
        rst = 1;
        a = 0;
        b = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: 2 + 3 (Unsigned)", test_num);
        reset_dut();
        a = 4'd2;
        b = 4'd3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: 8 + 8 (Carry Out Check)", test_num);
        reset_dut();
        a = 4'd8;
        b = 4'd8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: 15 + 15", test_num);
        reset_dut();
        a = 4'hF;
        b = 4'hF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'hE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: 0 + 0", test_num);
        reset_dut();
        a = 4'd0;
        b = 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: -1 + 1 (Signed logic)", test_num);
        reset_dut();
        a = 4'hF;
        b = 4'h1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: 7 + 1", test_num);
        reset_dut();
        a = 4'd7;
        b = 4'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: 15 + 1", test_num);
        reset_dut();
        a = 4'hF;
        b = 4'h1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: 12 + 0", test_num);
        reset_dut();
        a = 4'd12;
        b = 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd12);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,a, b, clk, rst, carry_out, sum);
    end

endmodule
