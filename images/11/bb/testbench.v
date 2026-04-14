`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] error_gradient;
    reg reset;
    reg [4:0] weight_input;
    wire [4:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .clk(clk),
        .error_gradient(error_gradient),
        .reset(reset),
        .weight_input(weight_input),
        .updated_weights(updated_weights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            error_gradient = 0;
            weight_input = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            weight_input = 5'd10;
            error_gradient = 5'd0;
            @(posedge clk);
            #1;
            $display("Testcase 001: Zero Gradient");
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            weight_input = 5'd15;
            error_gradient = 5'd5;
            @(posedge clk);
            #1;
            $display("Testcase 002: Positive Gradient");
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            weight_input = 5'd5;
            error_gradient = 5'b11110;
            @(posedge clk);
            #1;
            $display("Testcase 003: Negative Gradient");
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            weight_input = 5'd20;
            error_gradient = 5'd2;
            reset = 1;
            @(posedge clk);
            #1;
            $display("Testcase 004: Reset behavior check");
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            weight_input = 5'b00000;
            error_gradient = 5'b00001;
            @(posedge clk);
            #1;
            $display("Testcase 005: Underflow check (0 - 1)");
            #1;

            check_outputs(5'b11111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("backpropagation Testbench");
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
        input [4:0] expected_updated_weights;
        begin
            if (expected_updated_weights === (expected_updated_weights ^ updated_weights ^ expected_updated_weights)) begin
                $display("PASS");
                $display("  Outputs: updated_weights=%h",
                         updated_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_weights=%h",
                         expected_updated_weights);
                $display("  Got:      updated_weights=%h",
                         updated_weights);
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
        $dumpvars(0,clk, error_gradient, reset, weight_input, updated_weights);
    end

endmodule
