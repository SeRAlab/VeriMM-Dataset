`timescale 1ns/1ps

module GradientDescent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_weight;
    reg [15:0] error;
    reg [15:0] learning_rate;
    reg reset;
    wire [15:0] updated_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GradientDescent dut (
        .clk(clk),
        .current_weight(current_weight),
        .error(error),
        .learning_rate(learning_rate),
        .reset(reset),
        .updated_weight(updated_weight)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_weight = 16'h0000;
            error = 16'h0000;
            learning_rate = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            current_weight = 16'd1000;
            error = 16'd0;
            learning_rate = 16'd5;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Error Update", test_num);
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            current_weight = 16'd2500;
            error = 16'd100;
            learning_rate = 16'd0;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Learning Rate Update", test_num);
            #1;

            check_outputs(16'd2500);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            current_weight = 16'd500;
            error = 16'd50;
            learning_rate = 16'd2;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Error Update", test_num);
            #1;

            check_outputs(16'd400);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            current_weight = 16'd100;
            error = 16'hFFF6;
            learning_rate = 16'd5;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Error Update", test_num);
            #1;

            check_outputs(16'd150);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            current_weight = 16'hAAAA;
            error = 16'h0001;
            learning_rate = 16'h0001;
            reset = 1;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset Check", test_num);
            #1;

            check_outputs(16'h0000);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("GradientDescent Testbench");
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
        input [15:0] expected_updated_weight;
        begin
            if (expected_updated_weight === (expected_updated_weight ^ updated_weight ^ expected_updated_weight)) begin
                $display("PASS");
                $display("  Outputs: updated_weight=%h",
                         updated_weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_weight=%h",
                         expected_updated_weight);
                $display("  Got:      updated_weight=%h",
                         updated_weight);
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
        $dumpvars(0,clk, current_weight, error, learning_rate, reset, updated_weight);
    end

endmodule
