`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] y;
    wire [6:0] mem_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .mem_address(mem_address)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: x=0, y=0", test_num);
        x = 4'd0;
        y = 4'd0;

        #1;


        check_outputs(7'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: x=15, y=0", test_num);
        x = 4'd15;
        y = 4'd0;

        #1;


        check_outputs(7'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: x=0, y=1", test_num);
        x = 4'd0;
        y = 4'd1;

        #1;


        check_outputs(7'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: x=5, y=5", test_num);
        x = 4'd5;
        y = 4'd5;

        #1;


        check_outputs(7'd35);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: x=15, y=10", test_num);
        x = 4'd15;
        y = 4'd10;

        #1;


        check_outputs(7'd75);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: x=2, y=15", test_num);
        x = 4'd2;
        y = 4'd15;

        #1;


        check_outputs(7'd92);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: x=15, y=15", test_num);
        x = 4'd15;
        y = 4'd15;

        #1;


        check_outputs(7'd105);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: x=8, y=4", test_num);
        x = 4'd8;
        y = 4'd4;

        #1;


        check_outputs(7'd32);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: x=4, y=8", test_num);
        x = 4'd4;
        y = 4'd8;

        #1;


        check_outputs(7'd52);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: x=1, y=12", test_num);
        x = 4'd1;
        y = 4'd12;

        #1;


        check_outputs(7'd73);
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
        input [6:0] expected_mem_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_address === (expected_mem_address ^ mem_address ^ expected_mem_address)) begin
                $display("PASS");
                $display("  Outputs: mem_address=%h",
                         mem_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_address=%h",
                         expected_mem_address);
                $display("  Got:      mem_address=%h",
                         mem_address);
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
