`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk500kHz;
    reg [3:0] state;
    wire [7:0] fets;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk500kHz(clk500kHz),
        .state(state),
        .fets(fets)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: State 0, Clock 0", test_num);
        state = 4'd0;
        clk500kHz = 1'b0;
        #20;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State 0, Clock 1", test_num);
        state = 4'd0;
        clk500kHz = 1'b1;
        #20;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State 1, Clock 0", test_num);
        state = 4'd1;
        clk500kHz = 1'b0;
        #20;


        #1;



        check_outputs(8'b00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State 1, Clock 1", test_num);
        state = 4'd1;
        clk500kHz = 1'b1;
        #20;

        #1;


        check_outputs(8'b00000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State 5, Clock 1", test_num);
        state = 4'd5;
        clk500kHz = 1'b1;
        #20;
        #1;

        check_outputs(8'b00000101);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State 5, Clock 0", test_num);
        state = 4'd5;
        clk500kHz = 1'b0;
        #20;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: State 15, Clock 1", test_num);
        state = 4'd15;
        clk500kHz = 1'b1;
        #20;
        #1;

        check_outputs(8'b00001111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Square Wave Toggling in State 10", test_num);
        state = 4'd10;
        clk500kHz = 1'b1; #10;
        clk500kHz = 1'b0; #10;
        clk500kHz = 1'b1; #10;
        #1;

        check_outputs(8'b00001010);
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
        input [7:0] expected_fets;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fets === (expected_fets ^ fets ^ expected_fets)) begin
                $display("PASS");
                $display("  Outputs: fets=%h",
                         fets);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fets=%h",
                         expected_fets);
                $display("  Got:      fets=%h",
                         fets);
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
