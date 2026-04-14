`timescale 1ns/1ps

module GradientDescent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    reg rst;
    reg [15:0] x_in;
    wire [15:0] x_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GradientDescent dut (
        .clk(clk),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .rst(rst),
        .x_in(x_in),
        .x_out(x_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            gradient = 0;
            learning_rate = 0;
            x_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic functional test", test_num);
            x_in = 16'd100;
            learning_rate = 16'd2;
            gradient = 16'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd80);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Zero gradient test", test_num);
            x_in = 16'd500;
            learning_rate = 16'd5;
            gradient = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Zero learning rate test", test_num);
            x_in = 16'd250;
            learning_rate = 16'd0;
            gradient = 16'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd250);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Result equals zero", test_num);
            x_in = 16'd50;
            learning_rate = 16'd10;
            gradient = 16'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Large values test", test_num);
            x_in = 16'd10000;
            learning_rate = 16'd100;
            gradient = 16'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Underflow test (Negative result)", test_num);
            x_in = 16'd10;
            learning_rate = 16'd2;
            gradient = 16'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: High value logic test", test_num);
            x_in = 16'hFFFF;
            learning_rate = 16'h00FF;
            gradient = 16'h0002;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("GradientDescent Testbench");
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
        input [15:0] expected_x_out;
        begin
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h",
                         x_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h",
                         expected_x_out);
                $display("  Got:      x_out=%h",
                         x_out);
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
        $dumpvars(0,clk, gradient, learning_rate, rst, x_in, x_out);
    end

endmodule
