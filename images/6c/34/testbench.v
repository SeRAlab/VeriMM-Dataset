`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] _input0;
    reg [31:0] _input1;
    reg [31:0] _input2;
    reg [31:0] _input3;
    reg [1:0] sel;
    wire [31:0] output_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._input0(_input0),
        ._input1(_input1),
        ._input2(_input2),
        ._input3(_input3),
        .sel(sel),
        .output_(output_)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select _input0 (00)", test_num);
            _input0 = 32'hDEADBEEF;
            _input1 = 32'h00000000;
            _input2 = 32'hFFFFFFFF;
            _input3 = 32'h12345678;
            sel = 2'b00;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select _input1 (01)", test_num);
            _input0 = 32'hAAAA_AAAA;
            _input1 = 32'h5555_5555;
            _input2 = 32'hCCCC_CCCC;
            _input3 = 32'h3333_3333;
            sel = 2'b01;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select _input2 (10)", test_num);
            _input0 = 32'h1111_1111;
            _input1 = 32'h2222_2222;
            _input2 = 32'h3333_3333;
            _input3 = 32'h4444_4444;
            sel = 2'b10;
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select _input3 (11)", test_num);
            _input0 = 32'hFEDCBA98;
            _input1 = 32'h76543210;
            _input2 = 32'h89ABCDEF;
            _input3 = 32'h01234567;
            sel = 2'b11;
            #1;

            check_outputs(32'h01234567);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs Zero", test_num);
            _input0 = 32'd0;
            _input1 = 32'd0;
            _input2 = 32'd0;
            _input3 = 32'd0;
            sel = 2'b10;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs All-Ones", test_num);
            _input0 = 32'hFFFFFFFF;
            _input1 = 32'hFFFFFFFF;
            _input2 = 32'hFFFFFFFF;
            _input3 = 32'hFFFFFFFF;
            sel = 2'b00;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Input Change while sel fixed", test_num);
            _input0 = 32'h1234_5678;
            _input1 = 32'h0000_0000;
            _input2 = 32'h0000_0000;
            _input3 = 32'h0000_0000;
            sel = 2'b00;
            #5;
            _input0 = 32'h8765_4321;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit Test", test_num);
            _input0 = 32'h0000_0001;
            _input1 = 32'h0000_0002;
            _input2 = 32'h0000_0004;
            _input3 = 32'h0000_0008;
            sel = 2'b11;
            #1;

            check_outputs(32'h0000_0008);
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
        input [31:0] expected_output_;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_ === (expected_output_ ^ output_ ^ expected_output_)) begin
                $display("PASS");
                $display("  Outputs: output_=%h",
                         output_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_=%h",
                         expected_output_);
                $display("  Got:      output_=%h",
                         output_);
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
