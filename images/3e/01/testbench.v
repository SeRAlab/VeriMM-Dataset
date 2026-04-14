`timescale 1ns/1ps

module neural_backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_data;
    reg [7:0] learning_rate;
    reg reset;
    reg [7:0] target_output;
    wire [7:0] output_data;
    wire [7:0] weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_backpropagation dut (
        .clk(clk),
        .input_data(input_data),
        .learning_rate(learning_rate),
        .reset(reset),
        .target_output(target_output),
        .output_data(output_data),
        .weight(weight)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            input_data = 0;
            learning_rate = 0;
            target_output = 0;
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
            $display("Testcase %0d: Basic Forward and Update", test_num);
            reset_dut();



            input_data = 8'd2;
            learning_rate = 8'd1;
            target_output = 8'd6;


            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(8'd2, 8'd9);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input - No Weight Change", test_num);
            reset_dut();

            input_data = 8'd0;
            learning_rate = 8'd5;
            target_output = 8'd10;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(8'd0, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Target Reached - No Update", test_num);
            reset_dut();

            input_data = 8'd2;
            learning_rate = 8'd2;
            target_output = 8'd2;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd2, 8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Learning Rate", test_num);
            reset_dut();

            input_data = 8'd5;
            learning_rate = 8'd0;
            target_output = 8'd0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd5, 8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Learning Step (Negative Update)", test_num);
            reset_dut();

            input_data = 8'd1;
            learning_rate = 8'd2;
            target_output = 8'd1;




            input_data = 8'd1;
            learning_rate = 8'd2;
            target_output = 8'd5;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd1, 8'd9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_backpropagation Testbench");
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
        input [7:0] expected_output_data;
        input [7:0] expected_weight;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data) &&
                expected_weight === (expected_weight ^ weight ^ expected_weight)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h, weight=%h",
                         output_data, weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h, weight=%h",
                         expected_output_data, expected_weight);
                $display("  Got:      output_data=%h, weight=%h",
                         output_data, weight);
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
        $dumpvars(0,clk, input_data, learning_rate, reset, target_output, output_data, weight);
    end

endmodule
