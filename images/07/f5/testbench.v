`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_parameter;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    reg rst;
    wire [15:0] new_parameter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .current_parameter(current_parameter),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .rst(rst),
        .new_parameter(new_parameter)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_parameter = 0;
            gradient = 0;
            learning_rate = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic positive update (100 - 2*5)", test_num);
            reset_dut();
            current_parameter = 16'd100;
            learning_rate = 16'd2;
            gradient = 16'd5;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd90);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Gradient", test_num);
            reset_dut();
            current_parameter = 16'd500;
            learning_rate = 16'd10;
            gradient = 16'd0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Learning Rate", test_num);
            reset_dut();
            current_parameter = 16'd1000;
            learning_rate = 16'd0;
            gradient = 16'd20;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large update step", test_num);
            reset_dut();
            current_parameter = 16'd2000;
            learning_rate = 16'd50;
            gradient = 16'd20;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative result (Two's Complement check)", test_num);
            reset_dut();
            current_parameter = 16'd50;
            learning_rate = 16'd1;
            gradient = 16'd60;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFF6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary check (Max value)", test_num);
            reset_dut();
            current_parameter = 16'hFFFF;
            learning_rate = 16'd1;
            gradient = 16'd1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFE);
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
        input [15:0] expected_new_parameter;
        begin
            if (expected_new_parameter === (expected_new_parameter ^ new_parameter ^ expected_new_parameter)) begin
                $display("PASS");
                $display("  Outputs: new_parameter=%h",
                         new_parameter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_parameter=%h",
                         expected_new_parameter);
                $display("  Got:      new_parameter=%h",
                         new_parameter);
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
        $dumpvars(0,clk, current_parameter, gradient, learning_rate, rst, new_parameter);
    end

endmodule
