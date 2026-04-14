`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] angle;
    reg [1:0] function_select;
    wire [31:0] function_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .angle(angle),
        .function_select(function_select),
        .function_value(function_value)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sine of 0 degrees", test_num);
        angle = 32'h00000000;
        function_select = 2'b00;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Cosine of 0 degrees", test_num);
        angle = 32'h00000000;
        function_select = 2'b01;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Tangent of 0 degrees", test_num);
        angle = 32'h00000000;
        function_select = 2'b10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sine of 90 degrees", test_num);
        angle = 32'h40000000;
        function_select = 2'b00;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Cosine of 90 degrees", test_num);
        angle = 32'h40000000;
        function_select = 2'b01;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sine of -90 degrees", test_num);
        angle = 32'hC0000000;
        function_select = 2'b00;
        #1;

        check_outputs(32'hC0000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Cosine of -90 degrees", test_num);
        angle = 32'hC0000000;
        function_select = 2'b01;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Tangent of 45 degrees", test_num);
        angle = 32'h20000000;
        function_select = 2'b10;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sine of 45 degrees", test_num);
        angle = 32'h20000000;
        function_select = 2'b00;
        #1;

        check_outputs(32'h2D413CCD);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Cosine of 180 degrees", test_num);
        angle = 32'h80000000;
        function_select = 2'b01;
        #1;

        check_outputs(32'hC0000000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_function_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_function_value === (expected_function_value ^ function_value ^ expected_function_value)) begin
                $display("PASS");
                $display("  Outputs: function_value=%h",
                         function_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: function_value=%h",
                         expected_function_value);
                $display("  Got:      function_value=%h",
                         function_value);
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
