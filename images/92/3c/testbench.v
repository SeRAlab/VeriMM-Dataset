`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] inst_i;
    reg [31:0] r1_i;
    wire [31:0] r1_shift_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inst_i(inst_i),
        .r1_i(r1_i),
        .r1_shift_o(r1_shift_o)
    );
    task start_test;

        input [127:0] name;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: %s", test_num, name);
        end
        endtask

    task testcase001;

    begin
        start_test("SLL - Shift 1 bit");
        inst_i = 7'b00_00001;
        r1_i   = 32'h0000_0001;
        #1;

        check_outputs(32'h0000_0002);
    end
        endtask

    task testcase002;

    begin
        start_test("SLL - Shift 31 bits to MSB");
        inst_i = 7'b00_11111;
        r1_i   = 32'h0000_0001;
        #1;

        check_outputs(32'h8000_0000);
    end
        endtask

    task testcase003;

    begin
        start_test("SRL - Logical Right Shift Negative Value");
        inst_i = 7'b01_00001;
        r1_i   = 32'h8000_0000;
        #1;

        check_outputs(32'h4000_0000);
    end
        endtask

    task testcase004;

    begin
        start_test("SRL - Shift 31 bits");
        inst_i = 7'b01_11111;
        r1_i   = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'h0000_0001);
    end
        endtask

    task testcase005;

    begin
        start_test("SRA - Sign Extension 1 bit (Negative)");
        inst_i = 7'b10_00001;
        r1_i   = 32'h8000_0000;
        #1;

        check_outputs(32'hC000_0000);
    end
        endtask

    task testcase006;

    begin
        start_test("SRA - Sign Extension 4 bits (Positive)");
        inst_i = 7'b10_00100;
        r1_i   = 32'h0000_00F0;
        #1;

        check_outputs(32'h0000_000F);
    end
        endtask

    task testcase007;

    begin
        start_test("SRA - Shift 31 bits (Negative)");
        inst_i = 7'b10_11111;
        r1_i   = 32'h8000_0000;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        start_test("SLL - Shift 0 bits");
        inst_i = 7'b00_00000;
        r1_i   = 32'hA5A5_5A5A;
        #1;

        check_outputs(32'hA5A5_5A5A);
    end
        endtask

    task testcase009;

    begin
        start_test("SRA - Shift 0 bits");
        inst_i = 7'b10_00000;
        r1_i   = 32'hFFFF_0000;
        #1;

        check_outputs(32'hFFFF_0000);
    end
        endtask

    task testcase010;

    begin
        start_test("SLL - Complex Pattern");
        inst_i = 7'b00_01000;
        r1_i   = 32'h0000_DEAF;
        #1;

        check_outputs(32'h00DE_AF00);
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
        input [31:0] expected_r1_shift_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r1_shift_o === (expected_r1_shift_o ^ r1_shift_o ^ expected_r1_shift_o)) begin
                $display("PASS");
                $display("  Outputs: r1_shift_o=%h",
                         r1_shift_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r1_shift_o=%h",
                         expected_r1_shift_o);
                $display("  Got:      r1_shift_o=%h",
                         r1_shift_o);
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
