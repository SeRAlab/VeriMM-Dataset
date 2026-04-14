`timescale 1ns/1ps

module GradientDescentOptimizer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_weight;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    wire [15:0] updated_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GradientDescentOptimizer dut (
        .clk(clk),
        .current_weight(current_weight),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .updated_weight(updated_weight)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            current_weight = 16'd0;
            gradient = 16'd0;
            learning_rate = 16'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Standard weight update", test_num);
            reset_dut();
            current_weight = 16'd100;
            learning_rate  = 16'd2;
            gradient       = 16'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd90);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero gradient (No change)", test_num);
            reset_dut();
            current_weight = 16'h00FF;
            learning_rate  = 16'd10;
            gradient       = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero learning rate (No change)", test_num);
            reset_dut();
            current_weight = 16'd1000;
            learning_rate  = 16'd0;
            gradient       = 16'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Update resulting in exactly zero", test_num);
            reset_dut();
            current_weight = 16'd500;
            learning_rate  = 16'd10;
            gradient       = 16'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative result (Underflow)", test_num);
            reset_dut();
            current_weight = 16'd10;
            learning_rate  = 16'd5;
            gradient       = 16'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large values update", test_num);
            reset_dut();
            current_weight = 16'h8000;
            learning_rate  = 16'h0080;
            gradient       = 16'h0040;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h6000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("GradientDescentOptimizer Testbench");
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
        input [15:0] expected_updated_weight;
        begin
            if (expected_updated_weight === (expected_updated_weight ^ updated_weight ^ expected_updated_weight)) begin
                $display("PASS");
                $display("  Outputs: updated_weight=%h",
                         updated_weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_weight=%h",
                         expected_updated_weight);
                $display("  Got:      updated_weight=%h",
                         updated_weight);
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
        $dumpvars(0,clk, current_weight, gradient, learning_rate, updated_weight);
    end

endmodule
