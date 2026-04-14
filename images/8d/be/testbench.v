`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_a;
    reg [3:0] input_b;
    reg [7:0] input_c;
    reg [15:0] input_d;
    wire output_x;
    wire [3:0] output_y;
    wire [7:0] output_z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_a(input_a),
        .input_b(input_b),
        .input_c(input_c),
        .input_d(input_d),
        .output_x(output_x),
        .output_y(output_y),
        .output_z(output_z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: input_a=0 (output_x should be 1)", test_num);
            input_a = 1'b0;
            input_b = 4'h5;
            input_c = 8'h00;
            input_d = 16'h0000;
            #1;

            check_outputs(1'b1, 4'h5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: input_a=1 (output_x should be 0)", test_num);
            input_a = 1'b1;
            input_b = 4'hA;
            input_c = 8'h00;
            input_d = 16'h0000;
            #1;

            check_outputs(1'b0, 4'hA, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check output_y masking (LSB 4 bits of input_b)", test_num);
            input_a = 1'b1;
            input_b = 4'hF;
            input_c = 8'hAA;
            input_d = 16'h5555;

            #1;


            check_outputs(1'b0, 4'hF, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check output_z masking (input_c OR input_d[7:0])", test_num);
            input_a = 1'b0;
            input_b = 4'h0;
            input_c = 8'hF0;
            input_d = 16'hABCD;

            #1;


            check_outputs(1'b1, 4'h0, 8'hFD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check upper bits of input_d are ignored", test_num);
            input_a = 1'b1;
            input_b = 4'h9;
            input_c = 8'h12;
            input_d = 16'hFF34;

            #1;


            check_outputs(1'b0, 4'h9, 8'h36);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            input_a = 1'b0;
            input_b = 4'h0;
            input_c = 8'h00;
            input_d = 16'h0000;
            #1;

            check_outputs(1'b1, 4'h0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs high (within relevant bitwidths)", test_num);
            input_a = 1'b1;
            input_b = 4'hF;
            input_c = 8'hFF;
            input_d = 16'hFFFF;
            #1;

            check_outputs(1'b0, 4'hF, 8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_output_x;
        input [3:0] expected_output_y;
        input [7:0] expected_output_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_x === (expected_output_x ^ output_x ^ expected_output_x) &&
                expected_output_y === (expected_output_y ^ output_y ^ expected_output_y) &&
                expected_output_z === (expected_output_z ^ output_z ^ expected_output_z)) begin
                $display("PASS");
                $display("  Outputs: output_x=%b, output_y=%h, output_z=%h",
                         output_x, output_y, output_z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_x=%b, output_y=%h, output_z=%h",
                         expected_output_x, expected_output_y, expected_output_z);
                $display("  Got:      output_x=%b, output_y=%h, output_z=%h",
                         output_x, output_y, output_z);
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
