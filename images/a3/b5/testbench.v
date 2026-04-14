`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] AluCtr;
    reg [31:0] read_data_1;
    reg [31:0] read_data_2;
    wire [31:0] Alu_Result;
    wire [1:0] Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AluCtr(AluCtr),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .Alu_Result(Alu_Result),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = 1;
        AluCtr = 3'b010;
        read_data_1 = 32'd100;
        read_data_2 = 32'd250;
        #1;

        check_outputs(32'd350, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        AluCtr = 3'b010;
        read_data_1 = 32'hFFFF_FFFF;
        read_data_2 = 32'h0000_0001;
        #1;

        check_outputs(32'h0000_0000, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        AluCtr = 3'b110;
        read_data_1 = 32'h0000_0055;
        read_data_2 = 32'h0000_0055;
        #1;

        check_outputs(32'h0000_0000, 2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        AluCtr = 3'b000;
        read_data_1 = 32'hAAAA_5555;
        read_data_2 = 32'hFFFF_0000;
        #1;

        check_outputs(32'hAAAA_0000, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        AluCtr = 3'b001;
        read_data_1 = 32'h1234_0000;
        read_data_2 = 32'h0000_5678;
        #1;

        check_outputs(32'h1234_5678, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        AluCtr = 3'b100;
        read_data_1 = 32'h0000_FFFF;
        read_data_2 = 32'hFFFF_0000;
        #1;

        check_outputs(32'h0000_0000, 2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        AluCtr = 3'b011;
        read_data_1 = 32'h0000_0001;
        read_data_2 = 32'd8;
        #1;

        check_outputs(32'h0000_0100, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        AluCtr = 3'b101;
        read_data_1 = 32'h8000_0000;
        read_data_2 = 32'd1;
        #1;

        check_outputs(32'h4000_0000, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        AluCtr = 3'b111;
        read_data_1 = 32'hFFFF_FFFE;
        read_data_2 = 32'h0000_0001;
        #1;

        check_outputs(32'h0000_0001, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        AluCtr = 3'b111;
        read_data_1 = 32'd500;
        read_data_2 = 32'd200;
        #1;

        check_outputs(32'h0000_0000, 2'b01);
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
        input [31:0] expected_Alu_Result;
        input [1:0] expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Alu_Result === (expected_Alu_Result ^ Alu_Result ^ expected_Alu_Result) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Alu_Result=%h, Zero=%h",
                         Alu_Result, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Alu_Result=%h, Zero=%h",
                         expected_Alu_Result, expected_Zero);
                $display("  Got:      Alu_Result=%h, Zero=%h",
                         Alu_Result, Zero);
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
