`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] ALU_OP;
    reg [4:0] R_Addr_A;
    reg [4:0] R_Addr_B;
    reg Reset;
    reg [4:0] W_Addr;
    reg Write_Reg;
    reg clk;
    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] LED;
    wire OF;
    wire ZF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_OP(ALU_OP),
        .R_Addr_A(R_Addr_A),
        .R_Addr_B(R_Addr_B),
        .Reset(Reset),
        .W_Addr(W_Addr),
        .Write_Reg(Write_Reg),
        .clk(clk),
        .A(A),
        .B(B),
        .LED(LED),
        .OF(OF),
        .ZF(ZF)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            ALU_OP = 3'b000;
            R_Addr_A = 5'd0;
            R_Addr_B = 5'd0;
            W_Addr = 5'd0;
            Write_Reg = 1'b0;
            @(negedge clk);
            Reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (0+0) and Write", test_num);
            reset_dut();
            ALU_OP = 3'b000;
            R_Addr_A = 5'd0;
            R_Addr_B = 5'd1;
            W_Addr = 5'd2;
            Write_Reg = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (0-0)", test_num);
            reset_dut();
            ALU_OP = 3'b001;
            R_Addr_A = 5'd5;
            R_Addr_B = 5'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical AND", test_num);
            reset_dut();
            ALU_OP = 3'b010;
            R_Addr_A = 5'd10;
            R_Addr_B = 5'd11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical OR", test_num);
            reset_dut();
            ALU_OP = 3'b011;
            R_Addr_A = 5'd0;
            R_Addr_B = 5'd31;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical XOR", test_num);
            reset_dut();
            ALU_OP = 3'b100;
            R_Addr_A = 5'd15;
            R_Addr_B = 5'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Shift Operations", test_num);
            reset_dut();
            ALU_OP = 3'b101;
            R_Addr_A = 5'd1;
            R_Addr_B = 5'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 1'b1);
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
        input [31:0] expected_A;
        input [31:0] expected_B;
        input [31:0] expected_LED;
        input expected_OF;
        input expected_ZF;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_LED === (expected_LED ^ LED ^ expected_LED) &&
                expected_OF === (expected_OF ^ OF ^ expected_OF) &&
                expected_ZF === (expected_ZF ^ ZF ^ expected_ZF)) begin
                $display("PASS");
                $display("  Outputs: A=%h, B=%h, LED=%h, OF=%b, ZF=%b",
                         A, B, LED, OF, ZF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, B=%h, LED=%h, OF=%b, ZF=%b",
                         expected_A, expected_B, expected_LED, expected_OF, expected_ZF);
                $display("  Got:      A=%h, B=%h, LED=%h, OF=%b, ZF=%b",
                         A, B, LED, OF, ZF);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ALU_OP, R_Addr_A, R_Addr_B, Reset, W_Addr, Write_Reg, clk, A, B, LED, OF, ZF);
    end

endmodule
