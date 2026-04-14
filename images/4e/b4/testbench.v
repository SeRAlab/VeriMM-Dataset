`timescale 1ns/1ps

module pipelined_multiplier_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
    reg rst;
    wire [31:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_multiplier dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .result(result),
        .valid(valid)
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
            $display("Testcase %0d: Simple multiplication (10 * 5)", test_num);
            reset_dut();
            a = 16'd10;
            b = 16'd5;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(32'd50, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Multiplication by zero (0 * 1234)", test_num);
            reset_dut();
            a = 16'd0;
            b = 16'd1234;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maximum values (FFFF * FFFF)", test_num);
            reset_dut();
            a = 16'hFFFF;
            b = 16'hFFFF;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(32'hFFFE0001, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Power of 2 (256 * 256)", test_num);
            reset_dut();
            a = 16'd256;
            b = 16'd256;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(32'd65536, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Arbitrary values (123 * 456)", test_num);
            reset_dut();
            a = 16'd123;
            b = 16'd456;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(32'd56088, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_multiplier Testbench");
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
        input [31:0] expected_result;
        input expected_valid;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
        $dumpvars(0,a, b, clk, rst, result, valid);
    end

endmodule
