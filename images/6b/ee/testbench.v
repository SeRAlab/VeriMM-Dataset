`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] color_depth_i;
    reg [31:0] color_i;
    reg [1:0] x_lsb_i;
    wire [31:0] mem_o;
    wire [3:0] sel_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .color_depth_i(color_depth_i),
        .color_i(color_i),
        .x_lsb_i(x_lsb_i),
        .mem_o(mem_o),
        .sel_o(sel_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: 8-bit depth, x_lsb=0", test_num);
        color_depth_i = 2'b00;
        color_i = 32'h0000_00A5;
        x_lsb_i = 2'b00;
        #1;

        check_outputs(32'h0000_00A5, 4'b0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: 8-bit depth, x_lsb=1", test_num);
        color_depth_i = 2'b00;
        color_i = 32'h0000_00B6;
        x_lsb_i = 2'b01;
        #1;

        check_outputs(32'h0000_B600, 4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: 8-bit depth, x_lsb=2", test_num);
        color_depth_i = 2'b00;
        color_i = 32'h0000_00C7;
        x_lsb_i = 2'b10;
        #1;

        check_outputs(32'h00C7_0000, 4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: 8-bit depth, x_lsb=3", test_num);
        color_depth_i = 2'b00;
        color_i = 32'h0000_00D8;
        x_lsb_i = 2'b11;
        #1;

        check_outputs(32'hD800_0000, 4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: 16-bit depth, x_lsb=0", test_num);
        color_depth_i = 2'b01;
        color_i = 32'h0000_1234;
        x_lsb_i = 2'b00;
        #1;

        check_outputs(32'h0000_1234, 4'b0011);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: 16-bit depth, x_lsb=2", test_num);
        color_depth_i = 2'b01;
        color_i = 32'h0000_5678;
        x_lsb_i = 2'b10;
        #1;

        check_outputs(32'h5678_0000, 4'b1100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: 8-bit depth, x_lsb=0, Max Value", test_num);
        color_depth_i = 2'b00;
        color_i = 32'hFFFF_FFFF;
        x_lsb_i = 2'b00;
        #1;

        check_outputs(32'h0000_00FF, 4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: 16-bit depth, x_lsb=2, Max Value", test_num);
        color_depth_i = 2'b01;
        color_i = 32'hFFFF_FFFF;
        x_lsb_i = 2'b10;
        #1;

        check_outputs(32'hFFFF_0000, 4'b1100);
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
        input [31:0] expected_mem_o;
        input [3:0] expected_sel_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_o === (expected_mem_o ^ mem_o ^ expected_mem_o) &&
                expected_sel_o === (expected_sel_o ^ sel_o ^ expected_sel_o)) begin
                $display("PASS");
                $display("  Outputs: mem_o=%h, sel_o=%h",
                         mem_o, sel_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_o=%h, sel_o=%h",
                         expected_mem_o, expected_sel_o);
                $display("  Got:      mem_o=%h, sel_o=%h",
                         mem_o, sel_o);
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
