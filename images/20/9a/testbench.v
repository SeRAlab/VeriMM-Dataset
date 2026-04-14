`timescale 1ns/1ps

module neural_network_layer_tb;

    // Testbench signals (sequential circuit)
    reg bias;
    reg clk;
    reg [3:0] features;
    reg reset;
    reg [3:0] weights;
    wire activated_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network_layer dut (
        .bias(bias),
        .clk(clk),
        .features(features),
        .reset(reset),
        .weights(weights),
        .activated_output(activated_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            features = 0;
            weights = 0;
            bias = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset condition and Zero inputs...");
            reset_dut();
            features = 4'd5;
            weights = 4'd0;
            bias = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Positive dot product activation...");
            reset_dut();
            features = 4'd2;
            weights = 4'd3;
            bias = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Activation via bias only...");
            reset_dut();
            features = 4'd0;
            weights = 4'd10;
            bias = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: All inputs zero...");
            reset_dut();
            features = 4'd0;
            weights = 4'd0;
            bias = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Maximum input values...");
            reset_dut();
            features = 4'hf;
            weights = 4'hf;
            bias = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_network_layer Testbench");
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
        input expected_activated_output;
        begin
            if (expected_activated_output === (expected_activated_output ^ activated_output ^ expected_activated_output)) begin
                $display("PASS");
                $display("  Outputs: activated_output=%b",
                         activated_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: activated_output=%b",
                         expected_activated_output);
                $display("  Got:      activated_output=%b",
                         activated_output);
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
        $dumpvars(0,bias, clk, features, reset, weights, activated_output);
    end

endmodule
