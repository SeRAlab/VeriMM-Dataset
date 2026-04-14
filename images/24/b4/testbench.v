`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_value;
    reg [15:0] gradient;
    reg [15:0] learning_rate;
    wire [15:0] new_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .current_value(current_value),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .new_value(new_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            current_value <= 16'd0;
            gradient      <= 16'd0;
            learning_rate <= 16'd0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero Learning Rate", test_num);
            reset_dut();
            current_value <= 16'd1000;
            learning_rate <= 16'd0;
            gradient      <= 16'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero Gradient", test_num);
            reset_dut();
            current_value <= 16'd2500;
            learning_rate <= 16'd10;
            gradient      <= 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd2500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Positive Gradient Update", test_num);
            reset_dut();
            current_value <= 16'd100;
            learning_rate <= 16'd2;
            gradient      <= 16'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Negative Gradient Update", test_num);
            reset_dut();
            current_value <= 16'd100;
            learning_rate <= 16'd2;
            gradient      <= 16'hFFF6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd120);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Large Step", test_num);
            reset_dut();
            current_value <= 16'd5000;
            learning_rate <= 16'd50;
            gradient      <= 16'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd2500);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Negative Result Wrap-around", test_num);
            reset_dut();
            current_value <= 16'd10;
            learning_rate <= 16'd1;
            gradient      <= 16'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Negative Current Value", test_num);
            reset_dut();
            current_value <= 16'hFF9C;
            learning_rate <= 16'd5;
            gradient      <= 16'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFF38);
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
        input [15:0] expected_new_value;
        begin
            if (expected_new_value === (expected_new_value ^ new_value ^ expected_new_value)) begin
                $display("PASS");
                $display("  Outputs: new_value=%h",
                         new_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_value=%h",
                         expected_new_value);
                $display("  Got:      new_value=%h",
                         new_value);
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
        $dumpvars(0,clk, current_value, gradient, learning_rate, new_value);
    end

endmodule
