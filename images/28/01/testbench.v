`timescale 1ns/1ps

module gradient_descent_optimizer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] gradient;
    reg rst;
    wire [15:0] weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent_optimizer dut (
        .clk(clk),
        .gradient(gradient),
        .rst(rst),
        .weight(weight)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            gradient = 16'h0000;
            @(posedge clk);
            #1 rst = 0;

            $display("Resetting DUT: Initial weight should be 0000");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero Gradient", test_num);
            reset_dut();
            gradient = 16'h0000;
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Positive Gradient", test_num);
            reset_dut();
            gradient = 16'h0005;
            @(posedge clk);
            #1;

            check_outputs(16'hFFFB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Negative Gradient", test_num);
            reset_dut();
            gradient = 16'hFFF6;
            @(posedge clk);
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Continuous Accumulation", test_num);
            reset_dut();
            gradient = 16'h000A;
            @(posedge clk);
            gradient = 16'h0014;
            @(posedge clk);
            #1;

            check_outputs(16'hFFE2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Large Gradient Update", test_num);
            reset_dut();
            gradient = 16'h7FFF;
            @(posedge clk);
            #1;

            check_outputs(16'h8001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Alternating Updates", test_num);
            reset_dut();
            gradient = 16'h0064;
            @(posedge clk);
            gradient = 16'hFF9C;
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent_optimizer Testbench");
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
        input [15:0] expected_weight;
        begin
            if (expected_weight === (expected_weight ^ weight ^ expected_weight)) begin
                $display("PASS");
                $display("  Outputs: weight=%h",
                         weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight=%h",
                         expected_weight);
                $display("  Got:      weight=%h",
                         weight);
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
        $dumpvars(0,clk, gradient, rst, weight);
    end

endmodule
