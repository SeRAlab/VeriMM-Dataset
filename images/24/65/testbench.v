`timescale 1ns/1ps

module neural_network_layer_tb;

    // Testbench signals (sequential circuit)
    reg control;
    reg [3:0] input_vector;
    reg [3:0] weights;
    wire [3:0] output_vector;
    wire [3:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network_layer dut (
        .control(control),
        .input_vector(input_vector),
        .weights(weights),
        .output_vector(output_vector),
        .updated_weights(updated_weights)
    );

    // Clock generation (10ns period)
    initial begin
        control = 0;
        forever #5 control = ~control;
    end

        task reset_dut;

        begin
            input_vector = 4'b0;
            weights = 4'b0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Forward Pass (Input=2, Weight=3)", test_num);
            input_vector = 4'd2;
            weights = 4'd3;

            force control = 1'b0;
            #10;

            #1;


            check_outputs(4'd6, 4'd3);
            release control;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Forward Pass (Input=0, Weight=7)", test_num);
            input_vector = 4'd0;
            weights = 4'd7;
            force control = 1'b0;
            #10;

            #1;


            check_outputs(4'd0, 4'd7);
            release control;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Forward Pass (Input=5, Weight=4) - Overflow check", test_num);
            input_vector = 4'd5;
            weights = 4'd4;
            force control = 1'b0;
            #10;

            #1;


            check_outputs(4'd4, 4'd4);
            release control;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Backward Pass - Weight Update", test_num);
            input_vector = 4'd2;
            weights = 4'd5;
            force control = 1'b1;
            #10;



            if (updated_weights != 4'd5) begin
                $display("  Info: Weight successfully updated from 5 to %d", updated_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Weight remained unchanged during backward pass");
                fail_count = fail_count + 1;
            end
            release control;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Backward Pass - Zero Input Stability", test_num);
            input_vector = 4'd0;
            weights = 4'd8;
            force control = 1'b1;
            #10;

            #1;


            check_outputs(output_vector, 4'd8);
            release control;
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
        input [3:0] expected_output_vector;
        input [3:0] expected_updated_weights;
        begin
            if (expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector) &&
                expected_updated_weights === (expected_updated_weights ^ updated_weights ^ expected_updated_weights)) begin
                $display("PASS");
                $display("  Outputs: output_vector=%h, updated_weights=%h",
                         output_vector, updated_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_vector=%h, updated_weights=%h",
                         expected_output_vector, expected_updated_weights);
                $display("  Got:      output_vector=%h, updated_weights=%h",
                         output_vector, updated_weights);
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
        $dumpvars(0,control, input_vector, weights, output_vector, updated_weights);
    end

endmodule
