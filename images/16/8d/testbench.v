`timescale 1ns/1ps

module gradient_descent_optimizer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] error_signal;
    reg [15:0] learning_rate;
    reg reset;
    wire [15:0] weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent_optimizer dut (
        .clk(clk),
        .error_signal(error_signal),
        .learning_rate(learning_rate),
        .reset(reset),
        .weight(weight)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        error_signal = 0;
        learning_rate = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic positive error update", test_num);
        reset_dut();

        learning_rate = 16'd2;
        error_signal = 16'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFF6);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero error signal", test_num);
        reset_dut();

        learning_rate = 16'd10;
        error_signal = 16'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative error signal", test_num);
        reset_dut();

        learning_rate = 16'd4;
        error_signal = 16'hFFFD;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h000C);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential updates over 3 cycles", test_num);
        reset_dut();



        learning_rate = 16'd1;
        error_signal = 16'd10;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFE2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large value product and wrap-around", test_num);
        reset_dut();

        learning_rate = 16'h0100;
        error_signal = 16'h0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Learning rate is zero", test_num);
        reset_dut();

        learning_rate = 16'd0;
        error_signal = 16'd100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_weight;
        begin
            if (expected_weight === (expected_weight ^ weight ^ expected_weight)) begin
                $display("PASS");
                $display("  Outputs: weight=%h",
                         weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight=%h",
                         expected_weight);
                $display("  Got:      weight=%h",
                         weight);
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
        $dumpvars(0,clk, error_signal, learning_rate, reset, weight);
    end

endmodule
