`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] S0;
    reg [31:0] S1;
    reg [31:0] S2;
    reg [31:0] S3;
    reg [31:0] S4;
    reg [31:0] S5;
    reg [31:0] S6;
    reg [31:0] S7;
    reg [2:0] Sel;
    wire [31:0] ALU_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .S4(S4),
        .S5(S5),
        .S6(S6),
        .S7(S7),
        .Sel(Sel),
        .ALU_out(ALU_out)
    );
    task testcase001;

    begin
        Sel = 3'b000;
        $display("Running testcase001: Select S0");
        #1;

        check_outputs(S0);
    end
        endtask

    task testcase002;

    begin
        Sel = 3'b001;
        $display("Running testcase002: Select S1");
        #1;

        check_outputs(S1);
    end
        endtask

    task testcase003;

    begin
        Sel = 3'b010;
        $display("Running testcase003: Select S2");
        #1;

        check_outputs(S2);
    end
        endtask

    task testcase004;

    begin
        Sel = 3'b011;
        $display("Running testcase004: Select S3");
        #1;

        check_outputs(S3);
    end
        endtask

    task testcase005;

    begin
        Sel = 3'b100;
        $display("Running testcase005: Select S4");
        #1;

        check_outputs(S4);
    end
        endtask

    task testcase006;

    begin
        Sel = 3'b101;
        $display("Running testcase006: Select S5");
        #1;

        check_outputs(S5);
    end
        endtask

    task testcase007;

    begin
        Sel = 3'b110;
        $display("Running testcase007: Select S6");
        #1;

        check_outputs(S6);
    end
        endtask

    task testcase008;

    begin
        Sel = 3'b111;
        $display("Running testcase008: Select S7");
        #1;

        check_outputs(S7);
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
        input [31:0] expected_ALU_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_out === (expected_ALU_out ^ ALU_out ^ expected_ALU_out)) begin
                $display("PASS");
                $display("  Outputs: ALU_out=%h",
                         ALU_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_out=%h",
                         expected_ALU_out);
                $display("  Got:      ALU_out=%h",
                         ALU_out);
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
