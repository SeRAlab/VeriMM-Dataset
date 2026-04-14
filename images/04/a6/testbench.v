`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [15:0] gradient;
    reg [7:0] learning_rate;
    reg [15:0] weights_old;
    wire [15:0] weights_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .enable(enable),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .weights_old(weights_old),
        .weights_new(weights_new)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        gradient = 0;
        learning_rate = 0;
        weights_old = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Basic positive update", test_num);
        reset_dut();
        weights_old = 16'd1000;
        learning_rate = 8'd2;
        gradient = 16'd50;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(16'd900);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Zero learning rate", test_num);
        reset_dut();
        weights_old = 16'd500;
        learning_rate = 8'd0;
        gradient = 16'd100;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(16'd500);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Zero gradient", test_num);
        reset_dut();
        weights_old = 16'd750;
        learning_rate = 8'd10;
        gradient = 16'd0;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(16'd750);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Negative gradient (weights should increase)", test_num);
        reset_dut();
        weights_old = 16'd100;
        learning_rate = 8'd5;
        gradient = -16'd20;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(16'd200);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Large weight update", test_num);
        reset_dut();
        weights_old = 16'd5000;
        learning_rate = 8'd20;
        gradient = 16'd100;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(16'd3000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Enable signal validation", test_num);
        reset_dut();
        weights_old = 16'hAAAA;
        learning_rate = 8'd5;
        gradient = 16'd10;
        enable = 0;
        @(posedge clk);
        #1;



        if (weights_new == (16'hAAAA - (5 * 10))) begin
            $display("FAIL: Module updated while enable was low");
            fail_count = fail_count + 1;
        end else begin
            $display("PASS: Module remained idle while enable was low");
            pass_count = pass_count + 1;
        end
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Wrap-around check", test_num);
        reset_dut();
        weights_old = 16'd0;
        learning_rate = 8'd1;
        gradient = 16'd1;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        #1;

        check_outputs(16'hFFFF);
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
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_weights_new;
        begin
            if (expected_weights_new === (expected_weights_new ^ weights_new ^ expected_weights_new)) begin
                $display("PASS");
                $display("  Outputs: weights_new=%h",
                         weights_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weights_new=%h",
                         expected_weights_new);
                $display("  Got:      weights_new=%h",
                         weights_new);
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
        $dumpvars(0,clk, enable, gradient, learning_rate, weights_old, weights_new);
    end

endmodule
