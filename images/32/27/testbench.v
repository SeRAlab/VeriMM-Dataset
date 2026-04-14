`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] initial_x;
    reg [3:0] iterations;
    reg reset;
    wire [15:0] updated_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .initial_x(initial_x),
        .iterations(iterations),
        .reset(reset),
        .updated_x(updated_x)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Iteration (x=400, iter=1)", test_num);
            initial_x = 16'd400;
            iterations = 4'd1;
            reset_dut();
            repeat(1) @(posedge clk);
            #2 #1;
 check_outputs(16'h012C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Iterations (x=1024, iter=2)", test_num);
            initial_x = 16'd1024;
            iterations = 4'd2;
            reset_dut();
            repeat(2) @(posedge clk);
            #2 #1;
 check_outputs(16'h0240);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small values (x=16, iter=4)", test_num);
            initial_x = 16'd16;
            iterations = 4'd4;
            reset_dut();
            repeat(4) @(posedge clk);
            #2 #1;
 check_outputs(16'h0006);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Iterations (x=500, iter=0)", test_num);
            initial_x = 16'd500;
            iterations = 4'd0;
            reset_dut();
            #2 #1;
 check_outputs(16'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Start at Minima (x=0, iter=5)", test_num);
            initial_x = 16'd0;
            iterations = 4'd5;
            reset_dut();
            repeat(5) @(posedge clk);
            #2 #1;
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
        input [15:0] expected_updated_x;
        begin
            if (expected_updated_x === (expected_updated_x ^ updated_x ^ expected_updated_x)) begin
                $display("PASS");
                $display("  Outputs: updated_x=%h",
                         updated_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_x=%h",
                         expected_updated_x);
                $display("  Got:      updated_x=%h",
                         updated_x);
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
        $dumpvars(0,clk, initial_x, iterations, reset, updated_x);
    end

endmodule
