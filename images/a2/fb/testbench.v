`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    reg [4:0] shift;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .shift(shift),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift by 0", test_num);
        in = 32'hABCDE123;
        shift = 5'd0;
        #1;

        check_outputs(32'hABCDE123);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift by 1", test_num);
        in = 32'h80000001;
        shift = 5'd1;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift by 31", test_num);
        in = 32'h80000000;
        shift = 5'd31;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Check logical shift zero fill", test_num);
        in = 32'hFFFFFFFF;
        shift = 5'd4;
        #1;

        check_outputs(32'h0FFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift by 16", test_num);
        in = 32'h12345678;
        shift = 5'd16;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input is 0", test_num);
        in = 32'h00000000;
        shift = 5'd10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift resulting in all zeros", test_num);
        in = 32'h0000000F;
        shift = 5'd4;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bit pattern shift", test_num);
        in = 32'hAAAAAAAA;
        shift = 5'd2;
        #1;

        check_outputs(32'h2AAAAAAA);
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
        input [31:0] expected_out;
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
