`timescale 1ns/1ps

module image_convolution_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] kernel;
    reg [71:0] matrix;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .kernel(kernel),
        .matrix(matrix),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero", test_num);
            kernel = 3'd0;
            matrix = 72'h0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Kernel is zero, Matrix is non-zero", test_num);
            kernel = 3'd0;

            matrix = {9{8'hFF}};
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Kernel is 1, Matrix elements are all 1", test_num);
            kernel = 3'd1;

            matrix = {8'd1, 8'd1, 8'd1, 8'd1, 8'd1, 8'd1, 8'd1, 8'd1, 8'd1};
            #1;

            check_outputs(8'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Kernel is 2, Matrix elements are all 5", test_num);
            kernel = 3'd2;

            matrix = {9{8'd5}};
            #1;

            check_outputs(8'd90);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Kernel is 1, Matrix with mixed values (1 to 9)", test_num);
            kernel = 3'd1;

            matrix = {8'd9, 8'd8, 8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1};
            #1;

            check_outputs(8'd45);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Kernel is 5, specific sparse matrix", test_num);
            kernel = 3'd5;

            matrix = {8'd0, 8'd0, 8'd0, 8'd10, 8'd20, 8'd10, 8'd0, 8'd0, 8'd0};
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Kernel (7), small matrix values", test_num);
            kernel = 3'd7;

            matrix = {9{8'd3}};
            #1;

            check_outputs(8'd189);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large sum, kernel 1 (Boundary check)", test_num);
            kernel = 3'd1;

            matrix = {9{8'd25}};
            #1;

            check_outputs(8'd225);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("image_convolution Testbench");
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
