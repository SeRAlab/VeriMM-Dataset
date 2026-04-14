`timescale 1ns/1ps

module neural_network_layer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_weights;
    reg [7:0] inputs;
    reg rst;
    reg [7:0] target_output;
    wire [7:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network_layer dut (
        .clk(clk),
        .current_weights(current_weights),
        .inputs(inputs),
        .rst(rst),
        .target_output(target_output),
        .updated_weights(updated_weights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_weights = 0;
            inputs = 0;
            target_output = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Perfect Prediction", test_num);
            reset_dut();
            current_weights = 8'd5;
            inputs = 8'd2;
            target_output = 8'd10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input", test_num);
            reset_dut();
            current_weights = 8'd10;
            inputs = 8'd0;
            target_output = 8'd20;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Error - Weight Decrease", test_num);
            reset_dut();
            current_weights = 8'd10;
            inputs = 8'd2;
            target_output = 8'd10;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'hF6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Error - Weight Increase", test_num);
            reset_dut();
            current_weights = 8'd2;
            inputs = 8'd3;
            target_output = 8'd12;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Adjustment", test_num);
            reset_dut();
            current_weights = 8'd4;
            inputs = 8'd1;
            target_output = 8'd5;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd5);
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
        input [7:0] expected_updated_weights;
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
        $dumpvars(0,clk, current_weights, inputs, rst, target_output, updated_weights);
    end

endmodule
