`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALUop;
    reg [31:0] ina;
    reg [31:0] inb;
    wire [31:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .ina(ina),
        .inb(inb),
        .out(out),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (5 + 10)", test_num);
        ALUop = 4'b0000;
        ina = 32'd5;
        inb = 32'd10;
        #1;

        check_outputs(32'd15, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (0 + 0)", test_num);
        ALUop = 4'b0000;
        ina = 32'd0;
        inb = 32'd0;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (20 - 8)", test_num);
        ALUop = 4'b0001;
        ina = 32'd20;
        inb = 32'd8;
        #1;

        check_outputs(32'd12, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (15 - 15)", test_num);
        ALUop = 4'b0001;
        ina = 32'd15;
        inb = 32'd15;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise AND", test_num);
        ALUop = 4'b0010;
        ina = 32'hAAAA_FFFF;
        inb = 32'h5555_FFFF;
        #1;

        check_outputs(32'h0000_FFFF, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise OR", test_num);
        ALUop = 4'b0011;
        ina = 32'hAAAA_0000;
        inb = 32'h5555_FFFF;
        #1;

        check_outputs(32'hFFFF_FFFF, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise XOR", test_num);
        ALUop = 4'b0100;
        ina = 32'hFFFF_FFFF;
        inb = 32'hAAAA_AAAA;
        #1;

        check_outputs(32'h5555_5555, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Left Logical (1 << 4)", test_num);
        ALUop = 4'b0101;
        ina = 32'h0000_0001;
        inb = 32'd4;
        #1;

        check_outputs(32'h0000_0010, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Right Logical (16 >> 2)", test_num);
        ALUop = 4'b0110;
        ina = 32'h0000_0010;
        inb = 32'd2;
        #1;

        check_outputs(32'h0000_0004, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SLT Signed (-1 < 1)", test_num);
        ALUop = 4'b0111;
        ina = 32'hFFFF_FFFF;
        inb = 32'h0000_0001;
        #1;

        check_outputs(32'd1, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SLT Unsigned (MAX_UINT < 1)", test_num);
        ALUop = 4'b1000;
        ina = 32'hFFFF_FFFF;
        inb = 32'h0000_0001;
        #1;

        check_outputs(32'd0, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative result Zero flag check", test_num);
        ALUop = 4'b0001;
        ina = 32'd5;
        inb = 32'd10;
        #1;

        check_outputs(32'hFFFF_FFF9, 1'b0);
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
        input [31:0] expected_out;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: out=%h, zero=%b",
                         out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, zero=%b",
                         expected_out, expected_zero);
                $display("  Got:      out=%h, zero=%b",
                         out, zero);
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
