`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] In;
    wire [9:0] Out_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In(In),
        .Out_n(Out_n)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: BCD Input 0", test_num);
        In = 4'd0;
        #1;

        check_outputs(~10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: BCD Input 1", test_num);
        In = 4'd1;
        #1;

        check_outputs(~10'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: BCD Input 2", test_num);
        In = 4'd2;
        #1;

        check_outputs(~10'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: BCD Input 3", test_num);
        In = 4'd3;
        #1;

        check_outputs(~10'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: BCD Input 4", test_num);
        In = 4'd4;
        #1;

        check_outputs(~10'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: BCD Input 5", test_num);
        In = 4'd5;
        #1;

        check_outputs(~10'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: BCD Input 6", test_num);
        In = 4'd6;
        #1;

        check_outputs(~10'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: BCD Input 7", test_num);
        In = 4'd7;
        #1;

        check_outputs(~10'd7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: BCD Input 8", test_num);
        In = 4'd8;
        #1;

        check_outputs(~10'd8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: BCD Input 9", test_num);
        In = 4'd9;
        #1;

        check_outputs(~10'd9);
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
        input [9:0] expected_Out_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out_n === (expected_Out_n ^ Out_n ^ expected_Out_n)) begin
                $display("PASS");
                $display("  Outputs: Out_n=%h",
                         Out_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out_n=%h",
                         expected_Out_n);
                $display("  Got:      Out_n=%h",
                         Out_n);
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
