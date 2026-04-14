`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] alpha;
    reg clk;
    reg reset;
    reg [15:0] x_old;
    wire [15:0] x_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .alpha(alpha),
        .clk(clk),
        .reset(reset),
        .x_old(x_old),
        .x_new(x_new)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            alpha = 0;
            x_old = 0;
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
            $display("Testcase %0d: Positive x and alpha", test_num);
            reset_dut();
            x_old = 16'd10;
            alpha = 16'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFE2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alpha is zero", test_num);
            reset_dut();
            x_old = 16'd100;
            alpha = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0064);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative initial x", test_num);
            reset_dut();
            x_old = 16'hFFFB;
            alpha = 16'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial x is zero", test_num);
            reset_dut();
            x_old = 16'h0000;
            alpha = 16'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic descent iteration", test_num);
            reset_dut();
            x_old = 16'd20;
            alpha = 16'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFEC);
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
        input [15:0] expected_x_new;
        begin
            if (expected_x_new === (expected_x_new ^ x_new ^ expected_x_new)) begin
                $display("PASS");
                $display("  Outputs: x_new=%h",
                         x_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_new=%h",
                         expected_x_new);
                $display("  Got:      x_new=%h",
                         x_new);
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
        $dumpvars(0,alpha, clk, reset, x_old, x_new);
    end

endmodule
