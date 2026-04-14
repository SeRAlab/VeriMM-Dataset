`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a0;
    reg [31:0] a1;
    reg [31:0] a2;
    reg [31:0] a3;
    reg [5:0] addr;
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
        .addr(addr),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting a0 (addr = 6'b110000)", test_num);
            a0 = 32'hDEADBEEF;
            a1 = 32'h00000000;
            a2 = 32'h11111111;
            a3 = 32'h22222222;
            addr = 6'b110000;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting a1 (addr = 6'b110001)", test_num);
            a0 = 32'hAAAAAAAA;
            a1 = 32'hCAFEBABE;
            a2 = 32'hBBBBBBBB;
            a3 = 32'hCCCCCCCC;
            addr = 6'b110001;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting a2 (addr = 6'b110010)", test_num);
            a0 = 32'h00001111;
            a1 = 32'h22223333;
            a2 = 32'h12345678;
            a3 = 32'h44445555;
            addr = 6'b110010;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Selecting a3 (addr = 6'b110011)", test_num);
            a0 = 32'hFFFFFFFF;
            a1 = 32'hEEEEEEEE;
            a2 = 32'hDDDDDDDD;
            a3 = 32'h87654321;
            addr = 6'b110011;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify output changes when selected input changes", test_num);
            a0 = 32'h11223344;
            addr = 6'b110000;
            #5;
            a0 = 32'h55667788;
            #1;

            check_outputs(32'h55667788);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switching address while data is stable", test_num);
            a0 = 32'h00000001;
            a1 = 32'h00000002;
            a2 = 32'h00000004;
            a3 = 32'h00000008;
            addr = 6'b110010;
            #5;
            addr = 6'b110011;
            #1;

            check_outputs(32'h00000008);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs same value", test_num);
            a0 = 32'hA5A5A5A5;
            a1 = 32'hA5A5A5A5;
            a2 = 32'hA5A5A5A5;
            a3 = 32'hA5A5A5A5;
            addr = 6'b110001;
            #1;

            check_outputs(32'hA5A5A5A5);
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
