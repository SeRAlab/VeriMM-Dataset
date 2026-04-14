`timescale 1ns/1ps

module neural_network_layer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] input_vector;
    reg rst;
    reg [4:0] target_output;
    reg [4:0] weights;
    wire [4:0] adjusted_weights;
    wire [4:0] output_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network_layer dut (
        .clk(clk),
        .input_vector(input_vector),
        .rst(rst),
        .target_output(target_output),
        .weights(weights),
        .adjusted_weights(adjusted_weights),
        .output_vector(output_vector)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_vector = 5'b0;
            weights = 5'b0;
            target_output = 5'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic adjustment", test_num);
            reset_dut();
            input_vector = 5'd2;
            weights = 5'd3;
            target_output = 5'd10;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(5'd11, 5'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Perfect match (No error)", test_num);
            reset_dut();
            input_vector = 5'd4;
            weights = 5'd2;
            target_output = 5'd8;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(5'd2, 5'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative error adjustment", test_num);
            reset_dut();
            input_vector = 5'd1;
            weights = 5'd10;
            target_output = 5'd5;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(5'd5, 5'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow handling in output", test_num);
            reset_dut();
            input_vector = 5'd8;
            weights = 5'd5;
            target_output = 5'd10;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(5'd21, 5'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero input behavior", test_num);
            reset_dut();
            input_vector = 5'd0;
            weights = 5'd15;
            target_output = 5'd31;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(5'd15, 5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large adjustment wrap around", test_num);
            reset_dut();
            input_vector = 5'd3;
            weights = 5'd1;
            target_output = 5'd1;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(5'd27, 5'd3);
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
        input [4:0] expected_adjusted_weights;
        input [4:0] expected_output_vector;
        begin
            if (expected_adjusted_weights === (expected_adjusted_weights ^ adjusted_weights ^ expected_adjusted_weights) &&
                expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector)) begin
                $display("PASS");
                $display("  Outputs: adjusted_weights=%h, output_vector=%h",
                         adjusted_weights, output_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adjusted_weights=%h, output_vector=%h",
                         expected_adjusted_weights, expected_output_vector);
                $display("  Got:      adjusted_weights=%h, output_vector=%h",
                         adjusted_weights, output_vector);
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
        $dumpvars(0,clk, input_vector, rst, target_output, weights, adjusted_weights, output_vector);
    end

endmodule
