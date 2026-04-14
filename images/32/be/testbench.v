`timescale 1ns/1ps

module gradient_descent_optimizer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] grad;
    wire [15:0] x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent_optimizer dut (
        .clk(clk),
        .grad(grad),
        .x(x)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            grad = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Gradient", test_num);
            reset_dut();
            grad = 16'h0000;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Gradient (Single Step)", test_num);
            reset_dut();
            grad = 16'h0001;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Gradient (Single Step)", test_num);
            reset_dut();
            grad = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-Step Accumulation", test_num);
            reset_dut();
            grad = 16'h0002;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Step Convergence", test_num);
            reset_dut();
            grad = 16'h0064;
            repeat(2) @(posedge clk);
            #1 #1;
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
        input [15:0] expected_x;
        begin
            if (expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: x=%h",
                         x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h",
                         expected_x);
                $display("  Got:      x=%h",
                         x);
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
        $dumpvars(0,clk, grad, x);
    end

endmodule
