`timescale 1ns/1ps

module gradient_descent_optimizer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_weight;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    reg reset;
    wire [15:0] new_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent_optimizer dut (
        .clk(clk),
        .current_weight(current_weight),
        .gradient(gradient),
        .learning_rate(learning_rate),
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
            current_weight = 0;
            gradient = 0;
            learning_rate = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic positive update", test_num);
            reset_dut();
            current_weight = 16'd100;
            learning_rate  = 16'd2;
            gradient       = 16'd10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0050);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero gradient", test_num);
            reset_dut();
            current_weight = 16'd500;
            learning_rate  = 16'd10;
            gradient       = 16'd0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h01F4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero learning rate", test_num);
            reset_dut();
            current_weight = 16'hA000;
            learning_rate  = 16'h0000;
            gradient       = 16'h00FF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hA000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Underflow update", test_num);
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

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large values", test_num);
            reset_dut();
            current_weight = 16'd60000;
            learning_rate  = 16'd100;
            gradient       = 16'd200;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h9C40);
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
        $dumpvars(0,clk, current_weight, gradient, learning_rate, reset, new_weight);
    end

endmodule
