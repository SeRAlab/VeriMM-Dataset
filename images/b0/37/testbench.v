`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 64'h0;
        b = 64'h0;
        $display("Test %0d: 0 + 0", test_num);
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 64'h123;
        b = 64'h456;
        $display("Test %0d: Simple hex addition", test_num);
        #1;

        check_outputs(64'h579);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 64'h70000000_00000000;
        b = 64'h00000000_00000001;
        $display("Test %0d: Large value + 1", test_num);
        #1;

        check_outputs(64'h70000000_00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 64'hAAAAAAAAAAAAAAAA;
        b = 64'h5555555555555555;
        $display("Test %0d: Alternating bit patterns", test_num);
        #1;

        check_outputs(64'hFFFFFFFF_FFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 64'hFFFFFFFF_FFFFFFFF;
        b = 64'h00000000_00000001;
        $display("Test %0d: Wrap around (Max + 1)", test_num);
        #1;

        check_outputs(64'h00000000_00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 64'h12345678_9ABCDEF0;
        b = 64'h0FEDCBA9_87654321;
        $display("Test %0d: Random pattern addition", test_num);
        #1;

        check_outputs(64'h22222222_22222211);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 64'h00000000_FFFFFFFF;
        b = 64'h00000000_00000001;
        $display("Test %0d: Carry propagate to upper 32 bits", test_num);
        #1;

        check_outputs(64'h00000001_00000000);
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
        input [63:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
