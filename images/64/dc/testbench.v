`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [29:0] in0;
    reg [29:0] in1;
    reg [29:0] in2;
    reg [29:0] in3;
    reg [29:0] in4;
    reg sel0;
    reg sel1;
    reg sel2;
    reg sel3;
    reg sel4;
    wire [29:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .sel0(sel0),
        .sel1(sel1),
        .sel2(sel2),
        .sel3(sel3),
        .sel4(sel4),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select in0", test_num);
        in0 = 30'h1111_1111;
        in1 = 30'h2222_2222;
        in2 = 30'h3333_3333;
        in3 = 30'h4444_4444;
        in4 = 30'h5555_5555;
        sel0 = 1; sel1 = 0; sel2 = 0; sel3 = 0; sel4 = 0;
        #1;

        check_outputs(30'h1111_1111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select in1", test_num);
        in0 = 30'h1234_5678;
        in1 = 30'h2345_6789;
        in2 = 30'h3456_789A;
        in3 = 30'h4567_89AB;
        in4 = 30'h5678_9ABC;
        sel0 = 0; sel1 = 1; sel2 = 0; sel3 = 0; sel4 = 0;
        #1;

        check_outputs(30'h2345_6789);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select in2", test_num);
        in0 = 30'h0000_000A;
        in1 = 30'h0000_000B;
        in2 = 30'h0000_000C;
        in3 = 30'h0000_000D;
        in4 = 30'h0000_000E;
        sel0 = 0; sel1 = 0; sel2 = 1; sel3 = 0; sel4 = 0;
        #1;

        check_outputs(30'h0000_000C);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select in3", test_num);
        in0 = 30'h3FFF_FFFF;
        in1 = 30'h2AAA_AAAA;
        in2 = 30'h1555_5555;
        in3 = 30'h0F0F_0F0F;
        in4 = 30'h00FF_00FF;
        sel0 = 0; sel1 = 0; sel2 = 0; sel3 = 1; sel4 = 0;
        #1;

        check_outputs(30'h0F0F_0F0F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select in4", test_num);
        in0 = 30'h0000_0000;
        in1 = 30'h1111_1111;
        in2 = 30'h2222_2222;
        in3 = 30'h3333_3333;
        in4 = 30'h3FFF_FFFF;
        sel0 = 0; sel1 = 0; sel2 = 0; sel3 = 0; sel4 = 1;
        #1;

        check_outputs(30'h3FFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: All selects zero (default to 0)", test_num);
        in0 = 30'h1; in1 = 30'h2; in2 = 30'h3; in3 = 30'h4; in4 = 30'h5;
        sel0 = 0; sel1 = 0; sel2 = 0; sel3 = 0; sel4 = 0;
        #1;

        check_outputs(30'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select in0 with random data", test_num);
        in0 = 30'h2B6D_C351;
        in1 = 30'h1A2B_3C4D;
        in2 = 30'h0000_FFFF;
        in3 = 30'hFFFF_0000;
        in4 = 30'h1234_4321;
        sel0 = 1; sel1 = 0; sel2 = 0; sel3 = 0; sel4 = 0;
        #1;

        check_outputs(30'h2B6D_C351);
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
        input [29:0] expected_out;
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
