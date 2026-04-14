`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUFun;
    reg N;
    reg Sign;
    reg V;
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUFun(ALUFun),
        .N(N),
        .Sign(Sign),
        .V(V),
        .in1(in1),
        .in2(in2),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Equality - Equal", test_num);
        ALUFun = 3'b001; Sign = 1; in1 = 32'hA5A5A5A5; in2 = 32'hA5A5A5A5;
        N = 0; V = 0;
        #1;

        check_outputs(32'h1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Equality - Not Equal", test_num);
        ALUFun = 3'b001; Sign = 1; in1 = 32'hFFFFFFFF; in2 = 32'h00000001;
        N = 1; V = 0;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Inequality - Not Equal", test_num);
        ALUFun = 3'b000; Sign = 1; in1 = 32'd50; in2 = 32'd100;
        N = 1; V = 0;
        #1;

        check_outputs(32'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Inequality - Equal", test_num);
        ALUFun = 3'b000; Sign = 1; in1 = 32'd100; in2 = 32'd100;
        N = 0; V = 0;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Signed LT - True (Neg < Pos)", test_num);
        ALUFun = 3'b010; Sign = 1; in1 = 32'hFFFFFFFB; in2 = 32'd10;
        N = 1; V = 0;
        #1;

        check_outputs(32'h1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Signed LT - False (Pos > Neg)", test_num);
        ALUFun = 3'b010; Sign = 1; in1 = 32'd10; in2 = 32'hFFFFFFFB;
        N = 0; V = 0;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Signed LT - True (Overflow Case)", test_num);
        ALUFun = 3'b010; Sign = 1; in1 = 32'h80000000; in2 = 32'h00000001;
        N = 0; V = 1;
        #1;

        check_outputs(32'h1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Signed LT - False (Overflow Case)", test_num);
        ALUFun = 3'b010; Sign = 1; in1 = 32'h7FFFFFFF; in2 = 32'hFFFFFFFF;
        N = 1; V = 1;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Unsigned LT - True", test_num);
        ALUFun = 3'b010; Sign = 0; in1 = 32'h0000000A; in2 = 32'hFFFFFFFF;
        N = 1; V = 0;
        #1;

        check_outputs(32'h1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Unsigned LT - False", test_num);
        ALUFun = 3'b010; Sign = 0; in1 = 32'hFFFFFFFF; in2 = 32'h0000000A;
        N = 0; V = 0;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Signed LE - True (Equal)", test_num);
        ALUFun = 3'b011; Sign = 1; in1 = 32'd500; in2 = 32'd500;
        N = 0; V = 0;
        #1;

        check_outputs(32'h1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Signed LE - True (Less)", test_num);
        ALUFun = 3'b011; Sign = 1; in1 = 32'hFFFFFFFE; in2 = 32'hFFFFFFFF;
        N = 1; V = 0;
        #1;

        check_outputs(32'h1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test %0d: Signed LE - False (Greater)", test_num);
        ALUFun = 3'b011; Sign = 1; in1 = 32'd10; in2 = 32'd5;
        N = 0; V = 0;
        #1;

        check_outputs(32'h0);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [31:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
