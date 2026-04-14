`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg sel;
    wire [3:0] y;
    wire [3:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y),
        .z(z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select A with sel=0", test_num);
        a = 4'b1010;
        b = 4'b0101;
        sel = 1'b0;
        #1;

        check_outputs(4'b1010, 4'b1010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select B with sel=1", test_num);
        a = 4'b1010;
        b = 4'b0101;
        sel = 1'b1;
        #1;

        check_outputs(4'b0101, 4'b0101);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select A (All Zeros vs All Ones)", test_num);
        a = 4'b0000;
        b = 4'b1111;
        sel = 1'b0;
        #1;

        check_outputs(4'b0000, 4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select B (All Zeros vs All Ones)", test_num);
        a = 4'b0000;
        b = 4'b1111;
        sel = 1'b1;
        #1;

        check_outputs(4'b1111, 4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits pattern A", test_num);
        a = 4'b1100;
        b = 4'b0011;
        sel = 1'b0;
        #1;

        check_outputs(4'b1100, 4'b1100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits pattern B", test_num);
        a = 4'b1100;
        b = 4'b0011;
        sel = 1'b1;
        #1;

        check_outputs(4'b0011, 4'b0011);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern check", test_num);
        a = 4'h7;
        b = 4'hE;
        sel = 1'b0;
        #1;

        check_outputs(4'h7, 4'h7);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern check", test_num);
        a = 4'h7;
        b = 4'hE;
        sel = 1'b1;
        #1;

        check_outputs(4'hE, 4'hE);
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
        input [3:0] expected_y;
        input [3:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: y=%h, z=%h",
                         y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h, z=%h",
                         expected_y, expected_z);
                $display("  Got:      y=%h, z=%h",
                         y, z);
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
