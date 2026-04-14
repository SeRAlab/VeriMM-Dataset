`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] biases;
    reg clk;
    reg enable;
    reg [3:0] target;
    reg [3:0] weights;
    wire [3:0] updated_biases;
    wire [3:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .biases(biases),
        .clk(clk),
        .enable(enable),
        .target(target),
        .weights(weights),
        .updated_biases(updated_biases),
        .updated_weights(updated_weights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            weights = 0;
            biases = 0;
            target = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equilibrium (4+2=6)", test_num);
            reset_dut();
            weights = 4'd4;
            biases = 4'd2;
            target = 4'd6;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd2, 4'd4);
            enable = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Error (7+5=12 > 4)", test_num);
            reset_dut();
            weights = 4'd7;
            biases = 4'd5;
            target = 4'd4;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd1, 4'd3);
            enable = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Error (1+1=2 < 6)", test_num);
            reset_dut();
            weights = 4'd1;
            biases = 4'd1;
            target = 4'd6;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd3, 4'd3);
            enable = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs (Target 4)", test_num);
            reset_dut();
            weights = 4'd0;
            biases = 4'd0;
            target = 4'd4;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd2, 4'd2);
            enable = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values/Overflow", test_num);
            reset_dut();
            weights = 4'd8;
            biases = 4'd8;
            target = 4'd0;
            enable = 1;
            @(posedge clk);
            #2;



            #1;




            check_outputs(4'd0, 4'd0);
            enable = 0;
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
        input [3:0] expected_updated_biases;
        input [3:0] expected_updated_weights;
        begin
            if (expected_updated_biases === (expected_updated_biases ^ updated_biases ^ expected_updated_biases) &&
                expected_updated_weights === (expected_updated_weights ^ updated_weights ^ expected_updated_weights)) begin
                $display("PASS");
                $display("  Outputs: updated_biases=%h, updated_weights=%h",
                         updated_biases, updated_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_biases=%h, updated_weights=%h",
                         expected_updated_biases, expected_updated_weights);
                $display("  Got:      updated_biases=%h, updated_weights=%h",
                         updated_biases, updated_weights);
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
        $dumpvars(0,biases, clk, enable, target, weights, updated_biases, updated_weights);
    end

endmodule
