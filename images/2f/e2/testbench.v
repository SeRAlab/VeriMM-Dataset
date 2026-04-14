`timescale 1ns/1ps

module simple_neural_network_layer_tb;

    // Testbench signals (combinational circuit)
    reg bias;
    reg [4:0] inputs;
    reg [4:0] weights;
    wire [7:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_neural_network_layer dut (
        .bias(bias),
        .inputs(inputs),
        .weights(weights),
        .output_signal(output_signal)
    );
    task testcase001;

    begin
        $display("Test Case 001: All zeros");
        test_num = 1;
        inputs = 5'b00000;
        weights = 5'b00000;
        bias = 0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Maximum input/weight overlap (No Bias)");
        test_num = 2;
        inputs = 5'b11111;
        weights = 5'b11111;
        bias = 0;

        #1;


        check_outputs(8'h05);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Maximum input/weight overlap (With Bias)");
        test_num = 3;
        inputs = 5'b11111;
        weights = 5'b11111;
        bias = 1;

        #1;


        check_outputs(8'h06);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: No overlap between inputs and weights");
        test_num = 4;
        inputs = 5'b10101;
        weights = 5'b01010;
        bias = 0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Partial overlap");
        test_num = 5;
        inputs = 5'b11011;
        weights = 5'b10110;
        bias = 0;


        #1;



        check_outputs(8'h02);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Partial overlap with bias");
        test_num = 6;
        inputs = 5'b11011;
        weights = 5'b10110;
        bias = 1;


        #1;



        check_outputs(8'h03);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Only bias active");
        test_num = 7;
        inputs = 5'b00000;
        weights = 5'b11111;
        bias = 1;

        #1;


        check_outputs(8'h01);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Single matching bit");
        test_num = 8;
        inputs = 5'b00100;
        weights = 5'b00100;
        bias = 0;

        #1;


        check_outputs(8'h01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_neural_network_layer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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

endmodule
