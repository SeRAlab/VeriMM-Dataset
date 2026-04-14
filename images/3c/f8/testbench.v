`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] input_1;
    reg [1:0] input_2;
    reg [1:0] learning_rate;
    reg [1:0] target_output;
    reg [1:0] weight_1;
    reg [1:0] weight_2;
    wire [1:0] updated_weight_1;
    wire [1:0] updated_weight_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .input_1(input_1),
        .input_2(input_2),
        .learning_rate(learning_rate),
        .target_output(target_output),
        .weight_1(weight_1),
        .weight_2(weight_2),
        .updated_weight_1(updated_weight_1),
        .updated_weight_2(updated_weight_2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Perfect Match", test_num);
        weight_1 = 2'b01; weight_2 = 2'b01;
        input_1  = 2'b01; input_2  = 2'b00;
        learning_rate = 2'b01; target_output = 2'b01;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive Error (Decrease weight)", test_num);
        weight_1 = 2'b01; weight_2 = 2'b01;
        input_1  = 2'b01; input_2  = 2'b00;
        learning_rate = 2'b01; target_output = 2'b00;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative Error (Increase weight)", test_num);
        weight_1 = 2'b00; weight_2 = 2'b00;
        input_1  = 2'b01; input_2  = 2'b01;
        learning_rate = 2'b01; target_output = 2'b10;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Learning Rate", test_num);
        weight_1 = 2'b11; weight_2 = 2'b11;
        input_1  = 2'b01; input_2  = 2'b01;
        learning_rate = 2'b00; target_output = 2'b00;
        #1;

        check_outputs(2'b11, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complex Update", test_num);
        weight_1 = 2'b01; weight_2 = 2'b01;
        input_1  = 2'b10; input_2  = 2'b01;
        learning_rate = 2'b01; target_output = 2'b01;
        #1;

        check_outputs(2'b01, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High Value Update", test_num);
        weight_1 = 2'b11; weight_2 = 2'b11;
        input_1  = 2'b11; input_2  = 2'b11;
        learning_rate = 2'b01; target_output = 2'b01;
        #1;

        check_outputs(2'b00, 2'b00);
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
        input [1:0] expected_updated_weight_1;
        input [1:0] expected_updated_weight_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_updated_weight_1 === (expected_updated_weight_1 ^ updated_weight_1 ^ expected_updated_weight_1) &&
                expected_updated_weight_2 === (expected_updated_weight_2 ^ updated_weight_2 ^ expected_updated_weight_2)) begin
                $display("PASS");
                $display("  Outputs: updated_weight_1=%h, updated_weight_2=%h",
                         updated_weight_1, updated_weight_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_weight_1=%h, updated_weight_2=%h",
                         expected_updated_weight_1, expected_updated_weight_2);
                $display("  Got:      updated_weight_1=%h, updated_weight_2=%h",
                         updated_weight_1, updated_weight_2);
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
