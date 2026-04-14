`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] choose;
    reg [15:0] len;
    wire [7:0] threshhold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .choose(choose),
        .len(len),
        .threshhold(threshhold)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        len = 16'hABCD;
        choose = 4'h0;
        #10;
        $display("Test Case %0d: len=16'hABCD, choose=0 (Non-zero lower bits)", test_num);
        #1;

        check_outputs(8'hAB);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        len = 16'hAB00;
        choose = 4'h0;
        #10;
        $display("Test Case %0d: len=16'hAB00, choose=0 (Zero lower bits -> Decrement)", test_num);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        len = 16'h0100;
        choose = 4'h0;
        #10;
        $display("Test Case %0d: len=16'h0100, choose=0 (Zero lower bits -> 0x01-1)", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        len = 16'h0000;
        choose = 4'h0;
        #10;
        $display("Test Case %0d: len=16'h0000, choose=0 (Underflow check)", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        len = 16'hF0FF;
        choose = 4'h1;
        #10;
        $display("Test Case %0d: len=16'hF0FF, choose=1", test_num);

        #1;


        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        len = 16'hFFFF;
        choose = 4'hF;
        #10;
        $display("Test Case %0d: Max values len=FFFF, choose=F", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        len = 16'h1234;
        choose = 4'h8;
        #10;
        $display("Test Case %0d: len=16'h1234, choose=8", test_num);
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        len = 16'h5500;
        choose = 4'h4;
        #10;
        $display("Test Case %0d: len=16'h5500, choose=4 (Decrement check)", test_num);
        #1;

        check_outputs(8'h54);
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
        input [7:0] expected_threshhold;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_threshhold === (expected_threshhold ^ threshhold ^ expected_threshhold)) begin
                $display("PASS");
                $display("  Outputs: threshhold=%h",
                         threshhold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: threshhold=%h",
                         expected_threshhold);
                $display("  Got:      threshhold=%h",
                         threshhold);
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
