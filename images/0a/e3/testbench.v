`timescale 1ns/1ps

module gradient_descent_optimizer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_param;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    reg reset;
    wire [15:0] updated_param;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent_optimizer dut (
        .clk(clk),
        .current_param(current_param),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .reset(reset),
        .updated_param(updated_param)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_param = 16'd0;
            gradient = 16'd0;
            learning_rate = 16'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Gradient", test_num);
            reset_dut();
            current_param = 16'd1000;
            gradient = 16'd0;
            learning_rate = 16'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple Descent", test_num);
            reset_dut();
            current_param = 16'd500;
            gradient = 16'd20;
            learning_rate = 16'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd400);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Gradient (Ascent)", test_num);
            reset_dut();
            current_param = 16'd100;
            gradient = 16'hFFF6;
            learning_rate = 16'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Learning Rate", test_num);
            reset_dut();
            current_param = 16'd750;
            gradient = 16'd100;
            learning_rate = 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd750);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Gradient Step", test_num);
            reset_dut();
            current_param = 16'd10000;
            gradient = 16'd100;
            learning_rate = 16'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset = 1;
            current_param = 16'hAAAA;
            gradient = 16'hBBBB;
            learning_rate = 16'hCCCC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
            reset = 0;
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
        input [15:0] expected_updated_param;
        begin
            if (expected_updated_param === (expected_updated_param ^ updated_param ^ expected_updated_param)) begin
                $display("PASS");
                $display("  Outputs: updated_param=%h",
                         updated_param);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_param=%h",
                         expected_updated_param);
                $display("  Got:      updated_param=%h",
                         updated_param);
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
        $dumpvars(0,clk, current_param, gradient, learning_rate, reset, updated_param);
    end

endmodule
