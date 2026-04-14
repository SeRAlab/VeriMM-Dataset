`timescale 1ns/1ps

module GradientDescent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] current_value;
    reg [31:0] gradient;
    reg [31:0] learning_rate;
    reg rst;
    wire [31:0] updated_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GradientDescent dut (
        .clk(clk),
        .current_value(current_value),
        .gradient(gradient),
        .learning_rate(learning_rate),
        .rst(rst),
        .updated_value(updated_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        current_value = 0;
        gradient = 0;
        learning_rate = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;

        current_value = 32'd100;
        learning_rate = 32'd2;
        gradient      = 32'd10;

        @(posedge clk);
        #2;
        $display("Test %0d: Basic Descent (100 - 2*10)", test_num);
        #1;

        check_outputs(32'd80);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        current_value = 32'd50;
        learning_rate = 32'd5;
        gradient      = 32'd0;

        @(posedge clk);
        #2;
        $display("Test %0d: Zero Gradient", test_num);
        #1;

        check_outputs(32'd50);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        current_value = 32'd75;
        learning_rate = 32'd0;
        gradient      = 32'd10;

        @(posedge clk);
        #2;
        $display("Test %0d: Zero Learning Rate", test_num);
        #1;

        check_outputs(32'd75);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        current_value = 32'd100;
        learning_rate = 32'd2;
        gradient      = -32'd5;

        @(posedge clk);
        #2;
        $display("Test %0d: Negative Gradient (Ascent)", test_num);
        #1;

        check_outputs(32'd110);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        current_value = 32'd10;
        learning_rate = 32'd2;
        gradient      = 32'd10;

        @(posedge clk);
        #2;
        $display("Test %0d: Result resulting in negative value", test_num);
        #1;

        check_outputs(-32'd10);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        current_value = 32'd1000;
        learning_rate = 32'd10;
        gradient      = 32'd50;

        @(posedge clk);
        #2;
        $display("Test %0d: Larger integer values", test_num);
        #1;

        check_outputs(32'd500);
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
        input [31:0] expected_updated_value;
        begin
            if (expected_updated_value === (expected_updated_value ^ updated_value ^ expected_updated_value)) begin
                $display("PASS");
                $display("  Outputs: updated_value=%h",
                         updated_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_value=%h",
                         expected_updated_value);
                $display("  Got:      updated_value=%h",
                         updated_value);
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
        $dumpvars(0,clk, current_value, gradient, learning_rate, rst, updated_value);
    end

endmodule
