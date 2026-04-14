`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] in0;
    reg [17:0] in1;
    reg [17:0] in2;
    wire [17:0] out0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .out0(out0)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        in0 = 18'sd1000;
        in1 = 18'sd500;
        in2 = 18'sd100;
        $display("Testcase %0d: All positive, in0 is max", test_num);
        #1;

        check_outputs(18'sd1000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        in0 = 18'sd500;
        in1 = 18'sd1000;
        in2 = 18'sd100;
        $display("Testcase %0d: All positive, in1 is max", test_num);
        #1;

        check_outputs(18'sd1000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        in0 = 18'sd100;
        in1 = 18'sd500;
        in2 = 18'sd1000;
        $display("Testcase %0d: All positive, in2 is max", test_num);
        #1;

        check_outputs(18'sd1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in0 = -18'sd10;
        in1 = -18'sd50;
        in2 = -18'sd100;
        $display("Testcase %0d: All negative, in0 is max", test_num);
        #1;

        check_outputs(-18'sd10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        in0 = -18'sd50;
        in1 = -18'sd10;
        in2 = -18'sd100;
        $display("Testcase %0d: All negative, in1 is max", test_num);
        #1;

        check_outputs(-18'sd10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        in0 = -18'sd500;
        in1 = 18'sd0;
        in2 = 18'sd250;
        $display("Testcase %0d: Mixed positive/negative, in2 is max", test_num);
        #1;

        check_outputs(18'sd250);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        in0 = 18'h1FFFF;
        in1 = 18'h00000;
        in2 = 18'h20000;
        $display("Testcase %0d: Max positive vs Zero vs Min negative", test_num);
        #1;

        check_outputs(18'h1FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        in0 = 18'h20000;
        in1 = 18'h20001;
        in2 = 18'h3FFFF;
        $display("Testcase %0d: All negative near edges, in2 is max (-1)", test_num);
        #1;

        check_outputs(18'h3FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        in0 = 18'sd42;
        in1 = 18'sd42;
        in2 = 18'sd42;
        $display("Testcase %0d: All inputs equal", test_num);
        #1;

        check_outputs(18'sd42);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        in0 = -18'sd1;
        in1 = 18'sd0;
        in2 = -18'sd2;
        $display("Testcase %0d: Max is zero", test_num);
        #1;

        check_outputs(18'sd0);
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
        input [17:0] expected_out0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0)) begin
                $display("PASS");
                $display("  Outputs: out0=%h",
                         out0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h",
                         expected_out0);
                $display("  Got:      out0=%h",
                         out0);
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
