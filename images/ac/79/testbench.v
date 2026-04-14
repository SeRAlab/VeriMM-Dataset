`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg dir;
    reg rst_n;
    wire [5:0] counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .dir(dir),
        .rst_n(rst_n),
        .counter(counter)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Async Reset (dir=0)", test_num);
        dir = 0;
        rst_n = 0;
        #10;
        #1;

        check_outputs(6'd0);
        rst_n = 1;
        #10;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Async Reset (dir=1)", test_num);
        dir = 1;
        rst_n = 0;
        #10;
        #1;

        check_outputs(6'd63);
        rst_n = 1;
        #10;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Count Up 10 steps", test_num);
        rst_n = 0; dir = 0; #10; rst_n = 1;
        repeat(10) @(posedge clock);
        #1;

        check_outputs(6'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Count Down 5 steps", test_num);
        rst_n = 0; dir = 1; #10; rst_n = 1;
        repeat(5) @(posedge clock);
        #1;

        check_outputs(6'd58);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Wrap-around Up (65 steps)", test_num);
        rst_n = 0; dir = 0; #10; rst_n = 1;
        repeat(65) @(posedge clock);
        #1;

        check_outputs(6'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Wrap-around Down (65 steps)", test_num);
        rst_n = 0; dir = 1; #10; rst_n = 1;
        repeat(65) @(posedge clock);
        #1;

        check_outputs(6'd62);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Direction Change (Up 20, Down 5)", test_num);
        rst_n = 0; dir = 0; #10; rst_n = 1;
        repeat(20) @(posedge clock);
        dir = 1;
        repeat(5) @(posedge clock);
        #1;

        check_outputs(6'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset value change with Dir", test_num);
        rst_n = 0; dir = 0; #10;
        dir = 1; #10;
        #1;

        check_outputs(6'd63);
        rst_n = 1;
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
        input [5:0] expected_counter;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_counter === (expected_counter ^ counter ^ expected_counter)) begin
                $display("PASS");
                $display("  Outputs: counter=%h",
                         counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h",
                         expected_counter);
                $display("  Got:      counter=%h",
                         counter);
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
