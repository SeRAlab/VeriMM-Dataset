`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ALU_clk;
    reg Condition_update;
    reg [2:0] Func;
    reg Update;
    reg [7:0] X;
    reg [7:0] Y;
    reg [7:0] Zsoc;
    wire Carry;
    wire Overflow;
    wire Sign;
    wire [7:0] Z;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_clk(ALU_clk),
        .Condition_update(Condition_update),
        .Func(Func),
        .Update(Update),
        .X(X),
        .Y(Y),
        .Zsoc(Zsoc),
        .Carry(Carry),
        .Overflow(Overflow),
        .Sign(Sign),
        .Z(Z),
        .Zero(Zero)
    );

    // Clock generation (10ns period)
    initial begin
        ALU_clk = 0;
        forever #5 ALU_clk = ~ALU_clk;
    end

        task reset_dut;

    begin
        X = 8'h00;
        Y = 8'h00;
        Zsoc = 8'h00;
        Func = 3'b000;
        Update = 1'b0;
        Condition_update = 1'b0;
        @(posedge ALU_clk);
        #1;
    end
        endtask
    task trigger_alu;

    begin
        Update = 1'b1;
        Condition_update = 1'b1;
        @(posedge ALU_clk);
        #2;
        Update = 1'b0;
        Condition_update = 1'b0;
    end
        endtask

    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Basic Addition (10 + 20)");
        test_num = 1;
        X = 8'd10;
        Y = 8'd20;
        Func = 3'b000;
        trigger_alu();

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 8'h1E, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Addition with Carry (255 + 1)");
        test_num = 2;
        X = 8'hFF;
        Y = 8'h01;
        Func = 3'b000;
        trigger_alu();

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 8'h00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Addition Signed Overflow (127 + 1)");
        test_num = 3;
        X = 8'h7F;
        Y = 8'h01;
        Func = 3'b000;
        trigger_alu();

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 8'h80, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Basic Subtraction (50 - 20)");
        test_num = 4;
        X = 8'd50;
        Y = 8'd20;
        Func = 3'b001;
        trigger_alu();

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 8'h1E, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Subtraction with Borrow (10 - 20)");
        test_num = 5;
        X = 8'd10;
        Y = 8'd20;
        Func = 3'b001;
        trigger_alu();

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 8'hF6, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Bitwise AND (0xAA & 0xF0)");
        test_num = 6;
        X = 8'hAA;
        Y = 8'hF0;
        Func = 3'b010;
        trigger_alu();


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 8'hA0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase 007: Bitwise OR (0x0F | 0xF0)");
        test_num = 7;
        X = 8'h0F;
        Y = 8'hF0;
        Func = 3'b011;
        trigger_alu();
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 8'hFF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        $display("Testcase 008: Bitwise XOR (0x55 ^ 0xAA)");
        test_num = 8;
        X = 8'h55;
        Y = 8'hAA;
        Func = 3'b100;
        trigger_alu();
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 8'hFF, 1'b0);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        $display("Testcase 009: Zsoc Source pass-through");
        test_num = 9;
        Zsoc = 8'hBC;
        Func = 3'b111;
        trigger_alu();

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 8'hBC, 1'b0);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        $display("Testcase 010: Checking Update enable (No change when Update=0)");
        test_num = 10;


        X = 8'h11; Y = 8'h22; Func = 3'b000;
        Update = 1'b1; Condition_update = 1'b1;
        @(posedge ALU_clk); #1;


        X = 8'hFF; Y = 8'hFF;
        Update = 1'b0; Condition_update = 1'b0;
        @(posedge ALU_clk); #2;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 8'h33, 1'b0);
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
        input expected_Carry;
        input expected_Overflow;
        input expected_Sign;
        input [7:0] expected_Z;
        input expected_Zero;
        begin
            if (expected_Carry === (expected_Carry ^ Carry ^ expected_Carry) &&
                expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow) &&
                expected_Sign === (expected_Sign ^ Sign ^ expected_Sign) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Carry=%b, Overflow=%b, Sign=%b, Z=%h, Zero=%b",
                         Carry, Overflow, Sign, Z, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carry=%b, Overflow=%b, Sign=%b, Z=%h, Zero=%b",
                         expected_Carry, expected_Overflow, expected_Sign, expected_Z, expected_Zero);
                $display("  Got:      Carry=%b, Overflow=%b, Sign=%b, Z=%h, Zero=%b",
                         Carry, Overflow, Sign, Z, Zero);
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
        $dumpvars(0,ALU_clk, Condition_update, Func, Update, X, Y, Zsoc, Carry, Overflow, Sign, Z, Zero);
    end

endmodule
