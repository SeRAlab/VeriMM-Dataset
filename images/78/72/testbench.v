`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d;
    reg ena;
    wire g;
    wire [2:0] n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .ena(ena),
        .g(g),
        .n(n)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Module disabled (ena=0)", test_num);
        ena = 1'b0;
        d = 8'b11111111;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Enabled, no inputs active", test_num);
        ena = 1'b1;
        d = 8'b00000000;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input bit 0 active", test_num);
        ena = 1'b1;
        d = 8'b00000001;
        #1;

        check_outputs(1'b1, 3'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input bit 1 active", test_num);
        ena = 1'b1;
        d = 8'b00000010;
        #1;

        check_outputs(1'b1, 3'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input bit 2 active", test_num);
        ena = 1'b1;
        d = 8'b00000100;
        #1;

        check_outputs(1'b1, 3'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input bit 3 active", test_num);
        ena = 1'b1;
        d = 8'b00001000;
        #1;

        check_outputs(1'b1, 3'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input bit 4 active", test_num);
        ena = 1'b1;
        d = 8'b00010000;
        #1;

        check_outputs(1'b1, 3'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input bit 5 active", test_num);
        ena = 1'b1;
        d = 8'b00100000;
        #1;

        check_outputs(1'b1, 3'd5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Input bit 6 active", test_num);
        ena = 1'b1;
        d = 8'b01000000;
        #1;

        check_outputs(1'b1, 3'd6);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Input bit 7 active", test_num);
        ena = 1'b1;
        d = 8'b10000000;
        #1;

        check_outputs(1'b1, 3'd7);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Priority test (Bits 7 and 0 active)", test_num);
        ena = 1'b1;
        d = 8'b10000001;
        #1;

        check_outputs(1'b1, 3'd7);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Priority test (Bits 4, 3, 2 active)", test_num);
        ena = 1'b1;
        d = 8'b00011100;
        #1;

        check_outputs(1'b1, 3'd4);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: All bits active", test_num);
        ena = 1'b1;
        d = 8'b11111111;
        #1;

        check_outputs(1'b1, 3'd7);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input expected_g;
        input [2:0] expected_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g === (expected_g ^ g ^ expected_g) &&
                expected_n === (expected_n ^ n ^ expected_n)) begin
                $display("PASS");
                $display("  Outputs: g=%b, n=%h",
                         g, n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%b, n=%h",
                         expected_g, expected_n);
                $display("  Got:      g=%b, n=%h",
                         g, n);
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
