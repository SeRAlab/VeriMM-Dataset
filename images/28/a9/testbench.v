`timescale 1ns/1ps

module neural_network_layer_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] W1;
    reg [3:0] W2;
    reg [3:0] W3;
    reg [3:0] X1;
    reg [3:0] X2;
    reg [3:0] X3;
    reg clk;
    reg rst;
    reg [3:0] target;
    wire [3:0] new_W1;
    wire [3:0] new_W2;
    wire [3:0] new_W3;
    wire [3:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network_layer dut (
        .W1(W1),
        .W2(W2),
        .W3(W3),
        .X1(X1),
        .X2(X2),
        .X3(X3),
        .clk(clk),
        .rst(rst),
        .target(target),
        .new_W1(new_W1),
        .new_W2(new_W2),
        .new_W3(new_W3),
        .output_value(output_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            W1 = 0;
            W2 = 0;
            W3 = 0;
            X1 = 0;
            X2 = 0;
            X3 = 0;
            target = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            W1 = 4'sh1; W2 = 4'sh1; W3 = 4'sh1;
            X1 = 4'sh1; X2 = 4'sh1; X3 = 4'sh1;
            target = 4'sh5;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Basic Positive Update", test_num);
            #1;

            check_outputs(4'h3, 4'h3, 4'h3, 4'h3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            W1 = 4'sh4; W2 = 4'sh4; W3 = 4'sh4;
            X1 = 4'sh0; X2 = 4'sh0; X3 = 4'sh0;
            target = 4'sh5;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Zero Inputs (No Weight Change)", test_num);
            #1;

            check_outputs(4'h4, 4'h4, 4'h4, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            W1 = 4'sh2; W2 = -4'sh1; W3 = 4'sh0;
            X1 = 4'sh1; X2 = 4'sh2; X3 = 4'sh1;
            target = -4'sh2;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Negative Weights and Target", test_num);
            #1;

            check_outputs(4'h0, 4'hB, 4'hE, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            W1 = 4'sh1; W2 = 4'sh2; W3 = 4'sh3;
            X1 = 4'sh1; X2 = 4'sh0; X3 = 4'sh0;
            target = 4'sh1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Target matches Output (No Error)", test_num);
            #1;

            check_outputs(4'h1, 4'h2, 4'h3, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            W1 = 4'sh1; W2 = 4'sh1; W3 = 4'sh1;
            X1 = 4'sh1; X2 = 4'sh1; X3 = 4'sh1;
            target = -4'sh2;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Large Negative Error", test_num);
            #1;

            check_outputs(4'hC, 4'hC, 4'hC, 4'h3);
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
        input [3:0] expected_new_W1;
        input [3:0] expected_new_W2;
        input [3:0] expected_new_W3;
        input [3:0] expected_output_value;
        begin
            if (expected_new_W1 === (expected_new_W1 ^ new_W1 ^ expected_new_W1) &&
                expected_new_W2 === (expected_new_W2 ^ new_W2 ^ expected_new_W2) &&
                expected_new_W3 === (expected_new_W3 ^ new_W3 ^ expected_new_W3) &&
                expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: new_W1=%h, new_W2=%h, new_W3=%h, output_value=%h",
                         new_W1, new_W2, new_W3, output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_W1=%h, new_W2=%h, new_W3=%h, output_value=%h",
                         expected_new_W1, expected_new_W2, expected_new_W3, expected_output_value);
                $display("  Got:      new_W1=%h, new_W2=%h, new_W3=%h, output_value=%h",
                         new_W1, new_W2, new_W3, output_value);
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
        $dumpvars(0,W1, W2, W3, X1, X2, X3, clk, rst, target, new_W1, new_W2, new_W3, output_value);
    end

endmodule
