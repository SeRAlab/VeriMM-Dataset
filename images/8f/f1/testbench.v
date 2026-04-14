`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] A_new;
    reg clk;
    wire exit_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_new(A_new),
        .clk(clk),
        .exit_flag(exit_flag)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All segments all zeros", test_num);

        A_new = 256'h0;

        A_new[15:0]  = 16'h0000;
        A_new[31:16] = 16'h0000;
        A_new[47:32] = 16'h0000;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All segments all ones", test_num);
        A_new = 256'h0;
        A_new[15:0]  = 16'hFFFF;
        A_new[31:16] = 16'hFFFF;
        A_new[47:32] = 16'hFFFF;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed all-zeros and all-ones", test_num);
        A_new = 256'h0;
        A_new[15:0]  = 16'hFFFF;
        A_new[31:16] = 16'h0000;
        A_new[47:32] = 16'hFFFF;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: One segment contains mixed bits", test_num);
        A_new = 256'h0;
        A_new[15:0]  = 16'hFFFF;
        A_new[31:16] = 16'h8000;
        A_new[47:32] = 16'h0000;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Change bits outside targeted segments", test_num);
        A_new = {128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF, 128'h0};
        A_new[15:0]  = 16'h0000;
        A_new[31:16] = 16'h0000;
        A_new[47:32] = 16'h0000;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Segment with 15 ones and 1 zero", test_num);
        A_new = 256'h0;
        A_new[15:0]  = 16'hFFFE;
        A_new[31:16] = 16'hFFFF;
        A_new[47:32] = 16'hFFFF;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Segment with 15 zeros and 1 one", test_num);
        A_new = 256'h0;
        A_new[15:0]  = 16'h0000;
        A_new[31:16] = 16'h0000;
        A_new[47:32] = 16'h0004;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
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
        input expected_exit_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exit_flag === (expected_exit_flag ^ exit_flag ^ expected_exit_flag)) begin
                $display("PASS");
                $display("  Outputs: exit_flag=%b",
                         exit_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exit_flag=%b",
                         expected_exit_flag);
                $display("  Got:      exit_flag=%b",
                         exit_flag);
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
