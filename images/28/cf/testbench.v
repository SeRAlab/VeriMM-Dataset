`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg [15:0] lr;
    reg reset;
    reg [15:0] x;
    wire [15:0] theta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .d(d),
        .lr(lr),
        .reset(reset),
        .x(x),
        .theta(theta)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            lr = 0;
            x = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 16'd5;
            d = 16'd2;
            lr = 16'd10;
            @(posedge clk);
            #1;
            $display("Test Case 001: Positive inputs update");
            #1;

            check_outputs(16'hFF9C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 16'd5;
            d = 16'd2;
            lr = 16'd0;
            @(posedge clk);
            #1;
            $display("Test Case 002: Zero learning rate");
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 16'd2;
            d = 16'hFFFE;
            lr = 16'd5;
            @(posedge clk);
            #1;
            $display("Test Case 003: Negative gradient");
            #1;

            check_outputs(16'h0014);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 16'd0;
            d = 16'd100;
            lr = 16'd10;
            @(posedge clk);
            #1;
            $display("Test Case 004: Zero data point x");
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 16'd2;
            d = 16'd2;
            lr = 16'd2;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Test Case 005: Multi-cycle accumulation");
            #1;

            check_outputs(16'hFFF0);
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
        input [15:0] expected_theta;
        begin
            if (expected_theta === (expected_theta ^ theta ^ expected_theta)) begin
                $display("PASS");
                $display("  Outputs: theta=%h",
                         theta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: theta=%h",
                         expected_theta);
                $display("  Got:      theta=%h",
                         theta);
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
        $dumpvars(0,clk, d, lr, reset, x, theta);
    end

endmodule
