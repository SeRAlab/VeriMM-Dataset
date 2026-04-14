`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [1:0] ctr;
    wire [31:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .ctr(ctr),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'hA5A5A5A5;
            b = 32'hBBBBBBBB;
            c = 32'hCCCCCCCC;
            ctr = 2'b00;
            $display("Test %0d: Select input 'a' (ctr=00)", test_num);
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'hAAAAAAAA;
            b = 32'h12345678;
            c = 32'hCCCCCCCC;
            ctr = 2'b01;
            $display("Test %0d: Select input 'b' (ctr=01)", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'h0;
            b = 32'h55555555;
            c = 32'h0;
            ctr = 2'b10;
            $display("Test %0d: Select modified 'b' (ctr=10)", test_num);
            #1;

            check_outputs(32'h000000A8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'h11111111;
            b = 32'h22222222;
            c = 32'hDEADBEEF;
            ctr = 2'b11;
            $display("Test %0d: Select input 'c' (ctr=11)", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'h0;
            b = 32'hFFFFFFFF;
            c = 32'h0;
            ctr = 2'b10;
            $display("Test %0d: Select modified 'b' (ctr=10) with all ones", test_num);
            #1;

            check_outputs(32'h000000F8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'hFFFFFFFF;
            b = 32'h00000000;
            c = 32'hFFFFFFFF;
            ctr = 2'b10;
            $display("Test %0d: Select modified 'b' (ctr=10) with all zeros", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h11223344;
            b = 32'h55667788;
            c = 32'h99AABBCC;

            ctr = 2'b00; #1;
            ctr = 2'b11; #1;
            ctr = 2'b01;
            $display("Test %0d: Switching control signal rapidly to '01'", test_num);
            #1;

            check_outputs(32'h55667788);
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
        input [31:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
