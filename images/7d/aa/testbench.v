`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [31:0] in1;
    reg [31:0] in2;
    wire cout;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .in1(in1),
        .in2(in2),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        in1 = 32'h00000000; in2 = 32'h00000000; cin = 0;
        $display("Test %0d: Simple zero addition", test_num);
        #1;

        check_outputs(1'b0, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in1 = 32'h00000005; in2 = 32'h0000000A; cin = 0;
        $display("Test %0d: Small positive addition", test_num);
        #1;

        check_outputs(1'b0, 32'h0000000F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in1 = 32'h00000010; in2 = 32'h00000020; cin = 1;
        $display("Test %0d: Addition with cin set", test_num);
        #1;

        check_outputs(1'b0, 32'h00000031);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in1 = 32'hFFFFFFFF; in2 = 32'h00000001; cin = 0;
        $display("Test %0d: Max value + 1 (generates cout)", test_num);
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in1 = 32'hAAAAAAAA; in2 = 32'h55555555; cin = 0;
        $display("Test %0d: Alternating bit patterns", test_num);
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in1 = 32'hAAAAAAAA; in2 = 32'h55555555; cin = 1;
        $display("Test %0d: Alternating bits + cin (full ripple cout)", test_num);
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in1 = 32'h0000FFFF; in2 = 32'h00000001; cin = 0;
        $display("Test %0d: Internal carry propagation (16-bit boundary)", test_num);
        #1;

        check_outputs(1'b0, 32'h00010000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in1 = 32'h7FFFFFFF; in2 = 32'h00000001; cin = 0;
        $display("Test %0d: Sum to signed max positive", test_num);
        #1;

        check_outputs(1'b0, 32'h80000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in1 = 32'hFFFFFFFF; in2 = 32'hFFFFFFFF; cin = 1;
        $display("Test %0d: FFFFFFFF + FFFFFFFF + 1", test_num);
        #1;

        check_outputs(1'b1, 32'hFFFFFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in1 = 32'h12345678; in2 = 32'h87654321; cin = 0;
        $display("Test %0d: Random pattern addition", test_num);
        #1;

        check_outputs(1'b0, 32'h99999999);
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
        input expected_cout;
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
