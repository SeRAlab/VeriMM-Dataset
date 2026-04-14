`timescale 1ns/1ps

module gradient_descent_optimizer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_position;
    reg [15:0] learning_rate;
    reg reset;
    wire [15:0] next_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent_optimizer dut (
        .clk(clk),
        .current_position(current_position),
        .learning_rate(learning_rate),
        .reset(reset),
        .next_position(next_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_position = 0;
            learning_rate = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Basic gradient descent step");
            reset_dut();
            current_position = 16'd100;
            learning_rate = 16'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd90);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Zero learning rate (no movement)");
            reset_dut();
            current_position = 16'd500;
            learning_rate = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Step reaching zero exactly");
            reset_dut();
            current_position = 16'd40;
            learning_rate = 16'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Large position value");
            reset_dut();
            current_position = 16'd60000;
            learning_rate = 16'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd59800);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Underflow (Negative result)");
            reset_dut();
            current_position = 16'd10;
            learning_rate = 16'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Current position is zero");
            reset_dut();
            current_position = 16'd0;
            learning_rate = 16'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFF6);
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
        input [15:0] expected_next_position;
        begin
            if (expected_next_position === (expected_next_position ^ next_position ^ expected_next_position)) begin
                $display("PASS");
                $display("  Outputs: next_position=%h",
                         next_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_position=%h",
                         expected_next_position);
                $display("  Got:      next_position=%h",
                         next_position);
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
        $dumpvars(0,clk, current_position, learning_rate, reset, next_position);
    end

endmodule
