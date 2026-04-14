`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] DATA_A;
    reg [15:0] DATA_B;
    reg [3:0] S_ALU;
    wire [15:0] ALU_OUT;
    wire [3:0] FLAG_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_A(DATA_A),
        .DATA_B(DATA_B),
        .S_ALU(S_ALU),
        .ALU_OUT(ALU_OUT),
        .FLAG_OUT(FLAG_OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Simple Addition", test_num);
        DATA_A = 16'd10; DATA_B = 16'd20; S_ALU = 4'd0;
        #10;
        #1;

        check_outputs(16'd30, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition (Negative Result)", test_num);
        DATA_A = -16'd50; DATA_B = 16'd20; S_ALU = 4'd0;
        #10;
        #1;

        check_outputs(-16'd30, 4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction", test_num);
        DATA_A = 16'd100; DATA_B = 16'd40; S_ALU = 4'd1;
        #10;
        #1;

        check_outputs(16'd60, 4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (Zero Result)", test_num);
        DATA_A = 16'd15; DATA_B = 16'd15; S_ALU = 4'd1;
        #10;
        #1;

        check_outputs(16'd0, 4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Logical AND", test_num);
        DATA_A = 16'hAAAA; DATA_B = 16'hFFFF; S_ALU = 4'd2;
        #10;
        #1;

        check_outputs(16'hAAAA, 4'b0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Logical OR", test_num);
        DATA_A = 16'h5555; DATA_B = 16'hAAAA; S_ALU = 4'd3;
        #10;
        #1;

        check_outputs(16'hFFFF, 4'b0010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Logical XOR (Zero result)", test_num);
        DATA_A = 16'h1234; DATA_B = 16'h1234; S_ALU = 4'd4;
        #10;
        #1;

        check_outputs(16'h0000, 4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Logical Shift Left", test_num);
        DATA_A = 16'h0001; DATA_B = 16'h0004; S_ALU = 4'd5;
        #10;
        #1;

        check_outputs(16'h0010, 4'b0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Arithmetic Shift Right", test_num);
        DATA_A = 16'h8000; DATA_B = 16'h0001; S_ALU = 4'd7;
        #10;
        #1;

        check_outputs(16'hC000, 4'b0010);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Multiplication", test_num);
        DATA_A = 16'd50; DATA_B = 16'd10; S_ALU = 4'd8;
        #10;
        #1;

        check_outputs(16'd500, 4'b0000);
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
        input [15:0] expected_ALU_OUT;
        input [3:0] expected_FLAG_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_OUT === (expected_ALU_OUT ^ ALU_OUT ^ expected_ALU_OUT) &&
                expected_FLAG_OUT === (expected_FLAG_OUT ^ FLAG_OUT ^ expected_FLAG_OUT)) begin
                $display("PASS");
                $display("  Outputs: ALU_OUT=%h, FLAG_OUT=%h",
                         ALU_OUT, FLAG_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_OUT=%h, FLAG_OUT=%h",
                         expected_ALU_OUT, expected_FLAG_OUT);
                $display("  Got:      ALU_OUT=%h, FLAG_OUT=%h",
                         ALU_OUT, FLAG_OUT);
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
