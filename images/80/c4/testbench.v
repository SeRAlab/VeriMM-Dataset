`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] color_depth_i;
    reg [31:0] mem_i;
    reg [1:0] mem_lsb_i;
    wire [31:0] color_o;
    wire [3:0] sel_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .color_depth_i(color_depth_i),
        .mem_i(mem_i),
        .mem_lsb_i(mem_lsb_i),
        .color_o(color_o),
        .sel_o(sel_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 8-bit mode, Byte 0", test_num);
            color_depth_i = 2'b00;
            mem_i = 32'hAABBCCDD;
            mem_lsb_i = 2'b00;
            #1;

            check_outputs(32'h000000DD, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 8-bit mode, Byte 1", test_num);
            color_depth_i = 2'b00;
            mem_i = 32'hAABBCCDD;
            mem_lsb_i = 2'b01;
            #1;

            check_outputs(32'h000000CC, 4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 8-bit mode, Byte 2", test_num);
            color_depth_i = 2'b00;
            mem_i = 32'hAABBCCDD;
            mem_lsb_i = 2'b10;
            #1;

            check_outputs(32'h000000BB, 4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 8-bit mode, Byte 3", test_num);
            color_depth_i = 2'b00;
            mem_i = 32'hAABBCCDD;
            mem_lsb_i = 2'b11;
            #1;

            check_outputs(32'h000000AA, 4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 16-bit mode, Lower Half", test_num);
            color_depth_i = 2'b01;
            mem_i = 32'hAABBCCDD;
            mem_lsb_i = 2'b00;
            #1;

            check_outputs(32'h0000CCDD, 4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 16-bit mode, Upper Half", test_num);
            color_depth_i = 2'b01;
            mem_i = 32'hAABBCCDD;
            mem_lsb_i = 2'b10;
            #1;

            check_outputs(32'h0000AABB, 4'hC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 32-bit mode", test_num);
            color_depth_i = 2'b10;
            mem_i = 32'h12345678;
            mem_lsb_i = 2'b00;
            #1;

            check_outputs(32'h12345678, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Default mode check (Depth 11)", test_num);
            color_depth_i = 2'b11;
            mem_i = 32'h87654321;
            mem_lsb_i = 2'b11;
            #1;

            check_outputs(32'h87654321, 4'hF);
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
        input [31:0] expected_color_o;
        input [3:0] expected_sel_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_color_o === (expected_color_o ^ color_o ^ expected_color_o) &&
                expected_sel_o === (expected_sel_o ^ sel_o ^ expected_sel_o)) begin
                $display("PASS");
                $display("  Outputs: color_o=%h, sel_o=%h",
                         color_o, sel_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color_o=%h, sel_o=%h",
                         expected_color_o, expected_sel_o);
                $display("  Got:      color_o=%h, sel_o=%h",
                         color_o, sel_o);
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
