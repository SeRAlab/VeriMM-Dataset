`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUFun;
    reg Sign;
    reg [31:0] in1;
    reg [31:0] in2;
    wire N;
    wire [31:0] S;
    wire V;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUFun(ALUFun),
        .Sign(Sign),
        .in1(in1),
        .in2(in2),
        .N(N),
        .S(S),
        .V(V),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Addition 10 + 20", test_num);
        ALUFun = 1'b0; Sign = 1'b1; in1 = 32'd10; in2 = 32'd20;
        #1;

        check_outputs(1'b0, 32'd30, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Addition 15 + (-15)", test_num);
        ALUFun = 1'b0; Sign = 1'b1; in1 = 32'd15; in2 = -32'd15;
        #1;

        check_outputs(1'b0, 32'd0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Addition Overflow (Max + 1)", test_num);
        ALUFun = 1'b0; Sign = 1'b1; in1 = 32'h7FFFFFFF; in2 = 32'h00000001;
        #1;

        check_outputs(1'b1, 32'h80000000, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Addition Overflow (Min + Min)", test_num);
        ALUFun = 1'b0; Sign = 1'b1; in1 = 32'h80000000; in2 = 32'hFFFFFFFF;
        #1;

        check_outputs(1'b0, 32'h7FFFFFFF, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Subtraction 50 - 20", test_num);
        ALUFun = 1'b1; Sign = 1'b1; in1 = 32'd50; in2 = 32'd20;
        #1;

        check_outputs(1'b0, 32'd30, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Subtraction 10 - 20", test_num);
        ALUFun = 1'b1; Sign = 1'b1; in1 = 32'd10; in2 = 32'd20;
        #1;

        check_outputs(1'b1, -32'd10, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Signed Subtraction Overflow (Min - 1)", test_num);
        ALUFun = 1'b1; Sign = 1'b1; in1 = 32'h80000000; in2 = 32'h00000001;
        #1;

        check_outputs(1'b0, 32'h7FFFFFFF, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Unsigned Addition Wrap around", test_num);
        ALUFun = 1'b0; Sign = 1'b0; in1 = 32'hFFFFFFFF; in2 = 32'h00000002;

        #1;


        check_outputs(1'b0, 32'h00000001, 1'b0, 1'b0);
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
        input expected_N;
        input [31:0] expected_S;
        input expected_V;
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_N === (expected_N ^ N ^ expected_N) &&
                expected_S === (expected_S ^ S ^ expected_S) &&
                expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: N=%b, S=%h, V=%b, Z=%b",
                         N, S, V, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: N=%b, S=%h, V=%b, Z=%b",
                         expected_N, expected_S, expected_V, expected_Z);
                $display("  Got:      N=%b, S=%h, V=%b, Z=%b",
                         N, S, V, Z);
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
