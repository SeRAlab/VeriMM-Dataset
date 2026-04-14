`timescale 1ns/1ps

module ALU_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [1:0] ALU_Control;
    reg [31:0] B;
    wire [31:0] ALU_Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_32bit dut (
        .A(A),
        .ALU_Control(ALU_Control),
        .B(B),
        .ALU_Result(ALU_Result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (Basic 5 + 3)", test_num);
        A = 32'd5;
        B = 32'd3;
        ALU_Control = 2'b00;
        #1;

        check_outputs(32'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (32-bit Max + 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'd1;
        ALU_Control = 2'b00;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (10 - 4)", test_num);
        A = 32'd10;
        B = 32'd4;
        ALU_Control = 2'b01;
        #1;

        check_outputs(32'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (Result is negative: 5 - 10)", test_num);
        A = 32'd5;
        B = 32'd10;
        ALU_Control = 2'b01;
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND (0xF0F0 & 0xFFFF)", test_num);
        A = 32'hF0F0F0F0;
        B = 32'hFFFFFFFF;
        ALU_Control = 2'b10;
        #1;

        check_outputs(32'hF0F0F0F0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND (Opposing bits)", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        ALU_Control = 2'b10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs Zero", test_num);
        A = 32'h00000000;
        B = 32'h00000000;
        ALU_Control = 2'b00;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (Identical values)", test_num);
        A = 32'h12345678;
        B = 32'h12345678;
        ALU_Control = 2'b01;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_32bit Testbench");
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
        input [31:0] expected_ALU_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_Result === (expected_ALU_Result ^ ALU_Result ^ expected_ALU_Result)) begin
                $display("PASS");
                $display("  Outputs: ALU_Result=%h",
                         ALU_Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_Result=%h",
                         expected_ALU_Result);
                $display("  Got:      ALU_Result=%h",
                         ALU_Result);
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
