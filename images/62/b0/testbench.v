`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg sel;
    wire [63:0] res;

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
        .sel(sel),
        .res(res)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition mode with small values", test_num);
            a = 16'h0001;
            b = 16'h0002;
            c = 16'h0003;
            d = 16'h0004;
            sel = 1'b1;


            #1;



            check_outputs(64'h0002_0003_0007_0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction mode with simple values", test_num);
            a = 16'h000A;
            b = 16'h0005;
            c = 16'h0014;
            d = 16'h0008;
            sel = 1'b0;


            #1;



            check_outputs(64'h0005_0005_000C_000A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition mode with 16-bit overflow wrapping", test_num);
            a = 16'hFFFF;
            b = 16'h0001;
            c = 16'h8000;
            d = 16'h8000;
            sel = 1'b1;



            #1;




            check_outputs(64'h0001_0000_0000_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction mode with underflow (negative wrapping)", test_num);
            a = 16'h0000;
            b = 16'h0001;
            c = 16'h0005;
            d = 16'h0006;
            sel = 1'b0;



            #1;




            check_outputs(64'h0001_FFFF_FFFF_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed large values, Addition mode", test_num);
            a = 16'h1234;
            b = 16'h5678;
            c = 16'h9ABC;
            d = 16'hDEF0;
            sel = 1'b1;



            #1;




            check_outputs(64'h5678_68AC_79AC_1234);
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
        input [63:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
