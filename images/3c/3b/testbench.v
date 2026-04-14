`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_data;
    reg [7:0] learning_rate;
    reg [15:0] weights;
    wire [15:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .input_data(input_data),
        .learning_rate(learning_rate),
        .weights(weights),
        .updated_weights(updated_weights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            input_data = 16'd0;
            learning_rate = 8'd0;
            weights = 16'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Zero Learning Rate", test_num);

            weights = 16'h1234;
            learning_rate = 8'h00;
            input_data = 16'h00FF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Zero Gradient", test_num);

            weights = 16'hABCD;
            learning_rate = 8'hFF;
            input_data = 16'h0000;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Simple Positive Gradient", test_num);

            weights = 16'd1000;
            learning_rate = 8'd2;
            input_data = 16'd10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd980);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Negative Gradient", test_num);

            weights = 16'd2000;
            learning_rate = 8'd5;
            input_data = 16'hFFF6;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd2050);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Large Update/Underflow", test_num);

            weights = 16'h0010;
            learning_rate = 8'h10;
            input_data = 16'h0010;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFF10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Max Input Bounds", test_num);

            weights = 16'hFFFF;
            learning_rate = 8'h01;
            input_data = 16'h0001;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFE);
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
        input [15:0] expected_updated_weights;
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
        $dumpvars(0,clk, input_data, learning_rate, weights, updated_weights);
    end

endmodule
