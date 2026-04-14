`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .min(min)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs identical", test_num);
            a = 8'd42; b = 8'd42; c = 8'd42; d = 8'd42;
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Input 'a' is minimum", test_num);
            a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Input 'b' is minimum", test_num);
            a = 8'd50; b = 8'd5; c = 8'd15; d = 8'd25;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Input 'c' is minimum", test_num);
            a = 8'd100; b = 8'd90; c = 8'd80; d = 8'd110;
            #1;

            check_outputs(8'd80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Input 'd' is minimum", test_num);
            a = 8'd200; b = 8'd210; c = 8'd220; d = 8'd190;
            #1;

            check_outputs(8'd190);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All inputs are maximum value (255)", test_num);
            a = 8'hFF; b = 8'hFF; c = 8'hFF; d = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: One input is minimum value (0)", test_num);
            a = 8'd1; b = 8'd0; c = 8'd255; d = 8'd128;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Multiple inputs share the same minimum", test_num);
            a = 8'd15; b = 8'd30; c = 8'd15; d = 8'd50;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Values in descending order", test_num);
            a = 8'd40; b = 8'd30; c = 8'd20; d = 8'd10;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Boundary check with 8'h01 and 8'h00", test_num);
            a = 8'h01; b = 8'h01; c = 8'h01; d = 8'h00;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_min;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min === (expected_min ^ min ^ expected_min)) begin
                $display("PASS");
                $display("  Outputs: min=%h",
                         min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min=%h",
                         expected_min);
                $display("  Got:      min=%h",
                         min);
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
