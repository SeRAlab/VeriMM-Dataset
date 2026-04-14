`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] inputs;
    reg [7:0] learning_rate;
    reg reset;
    reg [4:0] target;
    reg [4:0] weights;
    wire [4:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .clk(clk),
        .inputs(inputs),
        .learning_rate(learning_rate),
        .reset(reset),
        .target(target),
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
            reset = 1;
            inputs = 0;
            learning_rate = 0;
            target = 0;
            weights = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target Reached (No Update)", test_num);


            inputs = 5'd1;
            learning_rate = 8'd10;
            target = 5'd5;
            weights = 5'd5;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Positive Error (Increase Weight)", test_num);



            inputs = 5'd1;
            learning_rate = 8'd1;
            target = 5'd6;
            weights = 5'd2;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd6);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Error (Decrease Weight)", test_num);


            inputs = 5'd1;
            learning_rate = 8'd1;
            target = 5'd4;
            weights = 5'd10;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Learning Rate", test_num);

            inputs = 5'd2;
            learning_rate = 8'd0;
            target = 5'd15;
            weights = 5'd5;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Input (Zero Gradient)", test_num);

            inputs = 5'd0;
            learning_rate = 8'd5;
            target = 5'd10;
            weights = 5'd7;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Scaled Update", test_num);


            inputs = 5'd1;
            learning_rate = 8'd1;
            target = 5'd12;
            weights = 5'd2;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'd12);
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
        $dumpvars(0,clk, inputs, learning_rate, reset, target, weights, updated_weights);
    end

endmodule
