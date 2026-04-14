`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg x;
    reg y;
    wire [7:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .x(x),
        .y(y),
        .c(c)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: x=1, y=0 (Output should be a)", test_num);
        a = 8'hAA;
        b = 8'h55;
        x = 1;
        y = 0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: x=1, y=1 (Output should be a - priority test)", test_num);
        a = 8'hF0;
        b = 8'h0F;
        x = 1;
        y = 1;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: x=0, y=1 (Output should be b)", test_num);
        a = 8'h12;
        b = 8'h34;
        x = 0;
        y = 1;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: x=0, y=0 (Output should be 0)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        x = 0;
        y = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: x=1, y=0 with all zeros", test_num);
        a = 8'h00;
        b = 8'hFF;
        x = 1;
        y = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: x=0, y=1 with all ones", test_num);
        a = 8'h00;
        b = 8'hFF;
        x = 0;
        y = 1;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
