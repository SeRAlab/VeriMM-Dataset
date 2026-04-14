`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] input_data;
    reg [15:0] learning_rate;
    reg [15:0] target_output;
    reg [15:0] weights;
    wire [15:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .input_data(input_data),
        .learning_rate(learning_rate),
        .target_output(target_output),
        .weights(weights),
        .updated_weights(updated_weights)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: No Error (Target matches prediction)", test_num);

            weights = 16'd5;
            input_data = 16'd2;
            target_output = 16'd10;
            learning_rate = 16'd1;
            #1;

            check_outputs(16'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Simple Positive Update", test_num);



            weights = 16'd1;
            input_data = 16'd2;
            target_output = 16'd6;
            learning_rate = 16'd1;
            #1;

            check_outputs(16'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Simple Negative Update", test_num);



            weights = 16'd10;
            input_data = 16'd1;
            target_output = 16'd5;
            learning_rate = 16'd2;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Zero Learning Rate", test_num);


            weights = 16'd7;
            input_data = 16'd3;
            target_output = 16'd20;
            learning_rate = 16'd0;
            #1;

            check_outputs(16'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Learning from Zero Weight", test_num);



            weights = 16'd0;
            input_data = 16'd4;
            target_output = 16'd2;
            learning_rate = 16'd2;
            #1;

            check_outputs(16'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Negative Weight Result (Underflow/Signed)", test_num);




            weights = 16'd3;
            input_data = 16'd2;
            target_output = 16'd1;
            learning_rate = 16'd1;
            #1;

            check_outputs(16'hFFF9);
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
        input [15:0] expected_updated_weights;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
