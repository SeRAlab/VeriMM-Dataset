`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a0;
    reg [31:0] a1;
    reg [31:0] a2;
    reg [31:0] a3;
    reg [1:0] s;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .s(s),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select a0 (s=00)", test_num);
            a0 = 32'hAAAA_AAAA;
            a1 = 32'h5555_5555;
            a2 = 32'h1234_5678;
            a3 = 32'h8765_4321;
            s  = 2'b00;
            #10;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select a1 (s=01)", test_num);
            a0 = 32'hAAAA_AAAA;
            a1 = 32'h5555_5555;
            a2 = 32'h1234_5678;
            a3 = 32'h8765_4321;
            s  = 2'b01;
            #10;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select a2 (s=10)", test_num);
            a0 = 32'hAAAA_AAAA;
            a1 = 32'h5555_5555;
            a2 = 32'h1234_5678;
            a3 = 32'h8765_4321;
            s  = 2'b10;
            #10;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select a3 (s=11)", test_num);
            a0 = 32'hAAAA_AAAA;
            a1 = 32'h5555_5555;
            a2 = 32'h1234_5678;
            a3 = 32'h8765_4321;
            s  = 2'b11;
            #10;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All inputs identical", test_num);
            a0 = 32'hFFFF_FFFF;
            a1 = 32'hFFFF_FFFF;
            a2 = 32'hFFFF_FFFF;
            a3 = 32'hFFFF_FFFF;
            s  = 2'b10;
            #10;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All zeros check", test_num);
            a0 = 32'h0000_0000;
            a1 = 32'h0000_0000;
            a2 = 32'h0000_0000;
            a3 = 32'h0000_0000;
            s  = 2'b01;
            #10;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Walking bit test on a0", test_num);
            a0 = 32'h8000_0000;
            a1 = 32'h0000_0001;
            a2 = 32'h0000_0002;
            a3 = 32'h0000_0004;
            s  = 2'b00;
            #10;
            #1;

            check_outputs(32'h8000_0000);
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
