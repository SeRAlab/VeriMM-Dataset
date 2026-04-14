`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [1:0] alu_ctr;
    reg [31:0] b;
    wire [31:0] alu_out;
    wire upover;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .alu_ctr(alu_ctr),
        .b(b),
        .alu_out(alu_out),
        .upover(upover),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition", test_num);
            a = 32'd100;
            b = 32'd250;
            alu_ctr = 2'b00;

            #1;


            check_outputs(32'd350, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Positive Overflow", test_num);
            a = 32'h7FFFFFFF;
            b = 32'h00000001;
            alu_ctr = 2'b00;

            #1;


            check_outputs(32'h80000000, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Negative Overflow", test_num);
            a = 32'h80000000;
            b = 32'hFFFFFFFF;
            alu_ctr = 2'b00;

            #1;


            check_outputs(32'h7FFFFFFF, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Zero flag check)", test_num);
            a = 32'hA5A5A5A5;
            b = 32'hA5A5A5A5;
            alu_ctr = 2'b01;

            #1;


            check_outputs(32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Non-zero)", test_num);
            a = 32'd500;
            b = 32'd499;
            alu_ctr = 2'b01;

            #1;


            check_outputs(32'h00000001, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            a = 32'hAAAA_5555;
            b = 32'h0000_FFFF;
            alu_ctr = 2'b10;

            #1;


            check_outputs(32'hAAAA_FFFF, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT (True case)", test_num);
            a = 32'hFFFF_FFFE;
            b = 32'hFFFF_FFFF;
            alu_ctr = 2'b11;

            #1;


            check_outputs(32'h0000_0001, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT (False case)", test_num);
            a = 32'd10;
            b = 32'd5;
            alu_ctr = 2'b11;

            #1;


            check_outputs(32'h0000_0000, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT (Mixed Signs)", test_num);
            a = 32'h8000_0000;
            b = 32'h0000_0001;
            alu_ctr = 2'b11;

            #1;


            check_outputs(32'h0000_0001, 1'b0, 1'b0);
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
        input [31:0] expected_alu_out;
        input expected_upover;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out) &&
                expected_upover === (expected_upover ^ upover ^ expected_upover) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h, upover=%b, zero=%b",
                         alu_out, upover, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h, upover=%b, zero=%b",
                         expected_alu_out, expected_upover, expected_zero);
                $display("  Got:      alu_out=%h, upover=%b, zero=%b",
                         alu_out, upover, zero);
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
