`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] alpha;
    reg clk;
    reg [3:0] x;
    wire [3:0] x_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .alpha(alpha),
        .clk(clk),
        .x(x),
        .x_next(x_next)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            alpha = 0;
            x = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 4'd10;
            alpha = 4'd3;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Basic Subtraction (10 - 3)", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 4'd5;
            alpha = 4'd0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Subtracting Zero (5 - 0)", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 4'd2;
            alpha = 4'd5;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Underflow Wrap-around (2 - 5)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 4'd15;
            alpha = 4'd15;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Maximum Values (15 - 15)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 4'd0;
            alpha = 4'd1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Minimum Boundary (0 - 1)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            x = 4'd1;
            alpha = 4'd10;
            @(posedge clk);
            #1;
            $display("Testcase %0d: High alpha (1 - 10)", test_num);
            #1;

            check_outputs(4'd7);
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
        input [3:0] expected_x_next;
        begin
            if (expected_x_next === (expected_x_next ^ x_next ^ expected_x_next)) begin
                $display("PASS");
                $display("  Outputs: x_next=%h",
                         x_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_next=%h",
                         expected_x_next);
                $display("  Got:      x_next=%h",
                         x_next);
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
        $dumpvars(0,alpha, clk, x, x_next);
    end

endmodule
