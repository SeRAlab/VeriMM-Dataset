`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUCtrl_i;
    reg [31:0] data0_i;
    reg [31:0] data1_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUCtrl_i(ALUCtrl_i),
        .data0_i(data0_i),
        .data1_i(data1_i),
        .data_o(data_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Bitwise AND", test_num);
        ALUCtrl_i = 3'b000;
        data0_i = 32'hAAAA_5555;
        data1_i = 32'hFFFF_0000;
        #1;

        check_outputs(32'hAAAA_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Bitwise OR", test_num);
        ALUCtrl_i = 3'b001;
        data0_i = 32'h1234_0000;
        data1_i = 32'h0000_5678;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Addition", test_num);
        ALUCtrl_i = 3'b010;
        data0_i = 32'd1000;
        data1_i = 32'd2000;
        #1;

        check_outputs(32'd3000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Addition Overflow", test_num);
        ALUCtrl_i = 3'b010;
        data0_i = 32'hFFFF_FFFF;
        data1_i = 32'h0000_0001;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Subtraction", test_num);
        ALUCtrl_i = 3'b011;
        data0_i = 32'd5000;
        data1_i = 32'd1500;
        #1;

        check_outputs(32'd3500);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Subtraction Negative", test_num);
        ALUCtrl_i = 3'b011;
        data0_i = 32'd10;
        data1_i = 32'd20;
        #1;

        check_outputs(32'hFFFF_FFF6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Multiplication", test_num);
        ALUCtrl_i = 3'b100;
        data0_i = 32'd50;
        data1_i = 32'd40;
        #1;

        check_outputs(32'd2000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Multiplication by Zero", test_num);
        ALUCtrl_i = 3'b100;
        data0_i = 32'hDEAD_BEEF;
        data1_i = 32'd0;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Default Output (ALUCtrl=7)", test_num);
        ALUCtrl_i = 3'b111;
        data0_i = 32'hFFFF_FFFF;
        data1_i = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'd0);
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
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
