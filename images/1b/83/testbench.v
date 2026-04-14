`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    reg [15:0] old_weight;
    reg reset;
    wire [15:0] new_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .old_weight(old_weight),
        .reset(reset),
        .new_weight(new_weight)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            gradient = 0;
            learning_rate = 0;
            old_weight = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset Verification");
            reset = 1;
            gradient = 16'h00FF;
            learning_rate = 16'h0002;
            old_weight = 16'h1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Basic Gradient Descent (Positive Result)");
            reset_dut();
            gradient = 16'd10;
            learning_rate = 16'd2;
            old_weight = 16'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd80);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Gradient Descent (Negative Result)");
            reset_dut();
            gradient = 16'd20;
            learning_rate = 16'd5;
            old_weight = 16'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFCE);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Zero Learning Rate");
            reset_dut();
            gradient = 16'd50;
            learning_rate = 16'd0;
            old_weight = 16'd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd200);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Zero Gradient");
            reset_dut();
            gradient = 16'd0;
            learning_rate = 16'd10;
            old_weight = 16'd500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Large Product Truncation");
            reset_dut();
            gradient = 16'h0100;
            learning_rate = 16'h0100;
            old_weight = 16'h1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Standard Update Step");
            reset_dut();
            gradient = 16'd100;
            learning_rate = 16'd2;
            old_weight = 16'd1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd800);
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
        input [15:0] expected_new_weight;
        begin
            if (expected_new_weight === (expected_new_weight ^ new_weight ^ expected_new_weight)) begin
                $display("PASS");
                $display("  Outputs: new_weight=%h",
                         new_weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_weight=%h",
                         expected_new_weight);
                $display("  Got:      new_weight=%h",
                         new_weight);
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
        $dumpvars(0,clk, gradient, learning_rate, old_weight, reset, new_weight);
    end

endmodule
