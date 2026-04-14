`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] da_data;
    reg sys_clk;
    reg sys_rst_n;
    wire da_clk_10b2;
    wire [9:0] da_out_10b2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .da_data(da_data),
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .da_clk_10b2(da_clk_10b2),
        .da_out_10b2(da_out_10b2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset and check with da_data = 8'h00", test_num);
            sys_rst_n = 0;
            da_data = 8'h00;
            #20;
            sys_rst_n = 1;
            #10;

            #1;


            check_outputs(1'b1, 10'b00000000_00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset and check with da_data = 8'hFF", test_num);
            sys_rst_n = 0;
            da_data = 8'hFF;
            #20;
            sys_rst_n = 1;
            #10;

            #1;


            check_outputs(1'b1, 10'b11111111_00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset and check with da_data = 8'hAA", test_num);
            sys_rst_n = 0;
            da_data = 8'hAA;
            #20;
            sys_rst_n = 1;
            #10;

            #1;


            check_outputs(1'b1, 10'b10101010_00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset and check with da_data = 8'h55", test_num);
            sys_rst_n = 0;
            da_data = 8'h55;
            #20;
            sys_rst_n = 1;
            #10;

            #1;


            check_outputs(1'b1, 10'b01010101_00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify clock inversion (sys_clk=1 phase)", test_num);
            sys_rst_n = 0;
            da_data = 8'h12;
            #20;
            sys_rst_n = 1;
            #15;

            #1;


            check_outputs(1'b0, 10'b00010010_00);
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
        input expected_da_clk_10b2;
        input [9:0] expected_da_out_10b2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_da_clk_10b2 === (expected_da_clk_10b2 ^ da_clk_10b2 ^ expected_da_clk_10b2) &&
                expected_da_out_10b2 === (expected_da_out_10b2 ^ da_out_10b2 ^ expected_da_out_10b2)) begin
                $display("PASS");
                $display("  Outputs: da_clk_10b2=%b, da_out_10b2=%h",
                         da_clk_10b2, da_out_10b2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: da_clk_10b2=%b, da_out_10b2=%h",
                         expected_da_clk_10b2, expected_da_out_10b2);
                $display("  Got:      da_clk_10b2=%b, da_out_10b2=%h",
                         da_clk_10b2, da_out_10b2);
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
