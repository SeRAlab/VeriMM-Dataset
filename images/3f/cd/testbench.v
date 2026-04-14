`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] initial_x;
    reg [3:0] iterations;
    reg [31:0] learning_rate;
    reg reset;
    wire done;
    wire [31:0] x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .initial_x(initial_x),
        .iterations(iterations),
        .learning_rate(learning_rate),
        .reset(reset),
        .done(done),
        .x(x)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            initial_x = 0;
            iterations = 0;
            learning_rate = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Start at minimum (x=5)", test_num);
            initial_x = 32'd5;
            learning_rate = 32'd1;
            iterations = 4'd10;
            reset_dut();

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Learning Rate", test_num);
            initial_x = 32'd20;
            learning_rate = 32'd0;
            iterations = 4'd5;
            reset_dut();

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Iterations", test_num);
            initial_x = 32'd42;
            learning_rate = 32'd1;
            iterations = 4'd0;
            reset_dut();

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'd42);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Iteration (x=10 -> x=0)", test_num);
            initial_x = 32'd10;
            learning_rate = 32'd1;
            iterations = 4'd1;
            reset_dut();

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two Iterations (Oscillation)", test_num);
            initial_x = 32'd10;
            learning_rate = 32'd1;
            iterations = 4'd2;
            reset_dut();

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Step from below minimum (x=2 -> x=8)", test_num);
            initial_x = 32'd2;
            learning_rate = 32'd1;
            iterations = 4'd1;
            reset_dut();

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Result Check (Negative x)", test_num);
            initial_x = 32'd15;
            learning_rate = 32'd1;
            iterations = 4'd1;
            reset_dut();

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'hFFFFFFFB);
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
        input expected_done;
        input [31:0] expected_x;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: done=%b, x=%h",
                         done, x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, x=%h",
                         expected_done, expected_x);
                $display("  Got:      done=%b, x=%h",
                         done, x);
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
        $dumpvars(0,clk, initial_x, iterations, learning_rate, reset, done, x);
    end

endmodule
