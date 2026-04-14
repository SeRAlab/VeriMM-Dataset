`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg clk;
    reg [3:0] iterations;
    reg [15:0] learning_rate;
    reg rst;
    wire [15:0] optimized_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .iterations(iterations),
        .learning_rate(learning_rate),
        .rst(rst),
        .optimized_x(optimized_x)
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
            c = 0;
            learning_rate = 0;
            iterations = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Step Gradient Descent (a=1, b=-6, LR=1, it=1)", test_num);
            reset_dut();
            a = 16'd1;
            b = -16'd6;
            c = 16'd0;
            learning_rate = 16'd1;
            iterations = 4'd1;
            repeat(iterations + 1) @(posedge clk);
            #1;

            check_outputs(16'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two Step Gradient Descent (a=1, b=-6, LR=1, it=2)", test_num);
            reset_dut();
            a = 16'd1;
            b = -16'd6;
            c = 16'd0;
            learning_rate = 16'd1;
            iterations = 4'd2;
            repeat(iterations + 1) @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Linear Descent (a=0, b=10, LR=2, it=3)", test_num);
            reset_dut();
            a = 16'd0;
            b = 16'd10;
            c = 16'd5;
            learning_rate = 16'd2;
            iterations = 4'd3;
            repeat(iterations + 1) @(posedge clk);
            #1;

            check_outputs(-16'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Learning Rate (LR=0)", test_num);
            reset_dut();
            a = 16'd5;
            b = 16'd10;
            c = 16'd2;
            learning_rate = 16'd0;
            iterations = 4'd5;
            repeat(iterations + 1) @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Gradient at Start (a=1, b=0, it=5)", test_num);
            reset_dut();
            a = 16'd1;
            b = 16'd0;
            c = 16'd0;
            learning_rate = 16'd1;
            iterations = 4'd5;
            repeat(iterations + 1) @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
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
        input [15:0] expected_optimized_x;
        begin
            if (expected_optimized_x === (expected_optimized_x ^ optimized_x ^ expected_optimized_x)) begin
                $display("PASS");
                $display("  Outputs: optimized_x=%h",
                         optimized_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: optimized_x=%h",
                         expected_optimized_x);
                $display("  Got:      optimized_x=%h",
                         optimized_x);
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
        $dumpvars(0,a, b, c, clk, iterations, learning_rate, rst, optimized_x);
    end

endmodule
