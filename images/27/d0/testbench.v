`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] gradient;
    reg [31:0] learning_rate;
    reg rst;
    reg [31:0] weight;
    wire [31:0] updated_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .rst(rst),
        .weight(weight),
        .updated_weight(updated_weight)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            gradient = 0;
            learning_rate = 0;
            weight = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            weight = 32'd100;
            learning_rate = 32'd0;
            gradient = 32'd50;
            @(posedge clk);
            #2;
            $display("Testcase %03d: Zero Learning Rate", test_num);
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            weight = 32'd1000;
            learning_rate = 32'd2;
            gradient = 32'd100;

            @(posedge clk);
            #2;
            $display("Testcase %03d: Standard Positive Update", test_num);
            #1;

            check_outputs(32'd800);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            weight = 32'd500;
            learning_rate = 32'd10;
            gradient = 32'd0;
            @(posedge clk);
            #2;
            $display("Testcase %03d: Zero Gradient", test_num);
            #1;

            check_outputs(32'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            weight = 32'd10;
            learning_rate = 32'd5;
            gradient = 32'd10;


            @(posedge clk);
            #2;
            $display("Testcase %03d: Negative Result Update", test_num);
            #1;

            check_outputs(32'hFFFFFFD8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            weight = 32'h0000FFFF;
            learning_rate = 32'd256;
            gradient = 32'd16;

            @(posedge clk);
            #2;
            $display("Testcase %03d: Large Values Update", test_num);
            #1;

            check_outputs(32'h0000EFFF);
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
        input [31:0] expected_updated_weight;
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
        $dumpvars(0,clk, gradient, learning_rate, rst, weight, updated_weight);
    end

endmodule
