`timescale 1ns/1ps

module neural_layer_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input1;
    reg [3:0] input2;
    reg [3:0] input3;
    wire [3:0] output1;
    wire [3:0] output2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_layer dut (
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .output1(output1),
        .output2(output2)
    );
    task testcase001;

        begin
            test_num = 1;
            input1 = 4'd0;
            input2 = 4'd0;
            input3 = 4'd0;


            $display("Test Case 001: All zeros");
            #1;

            check_outputs(4'd1, 4'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input1 = 4'd1;
            input2 = 4'd0;
            input3 = 4'd0;


            $display("Test Case 002: Input1 active");
            #1;

            check_outputs(4'd3, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input1 = 4'd0;
            input2 = 4'd1;
            input3 = 4'd0;


            $display("Test Case 003: Input2 active");
            #1;

            check_outputs(4'd4, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input1 = 4'd0;
            input2 = 4'd0;
            input3 = 4'd1;


            $display("Test Case 004: Input3 active");
            #1;

            check_outputs(4'd2, 4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input1 = 4'd1;
            input2 = 4'd1;
            input3 = 4'd1;


            $display("Test Case 005: All inputs = 1");
            #1;

            check_outputs(4'd7, 4'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            input1 = 4'd2;
            input2 = 4'd1;
            input3 = 4'd2;


            $display("Test Case 006: Medium range inputs (2,1,2)");
            #1;

            check_outputs(4'hA, 4'hA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            input1 = 4'd3;
            input2 = 4'd2;
            input3 = 4'd1;


            $display("Test Case 007: Inputs (3,2,1)");
            #1;

            check_outputs(4'hE, 4'hB);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            input1 = 4'd0;
            input2 = 4'd4;
            input3 = 4'd2;


            $display("Test Case 008: Boundary check (0,4,2)");
            #1;

            check_outputs(4'hF, 4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_layer Testbench");
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
        input [3:0] expected_output1;
        input [3:0] expected_output2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1) &&
                expected_output2 === (expected_output2 ^ output2 ^ expected_output2)) begin
                $display("PASS");
                $display("  Outputs: output1=%h, output2=%h",
                         output1, output2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%h, output2=%h",
                         expected_output1, expected_output2);
                $display("  Got:      output1=%h, output2=%h",
                         output1, output2);
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
