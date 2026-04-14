`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] accum;
    reg [7:0] alu_in;
    reg [2:0] op;
    wire [7:0] alu_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .accum(accum),
        .alu_in(alu_in),
        .op(op),
        .alu_out(alu_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: HLT (Op 0) - Should output accum", test_num);
            op = 3'b000;
            accum = 8'hAA;
            alu_in = 8'h55;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NOP (Op 1) - Should output accum", test_num);
            op = 3'b001;
            accum = 8'h12;
            alu_in = 8'h34;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADD (Op 2) - Basic addition", test_num);
            op = 3'b010;
            accum = 8'h10;
            alu_in = 8'h20;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND (Op 3) - Bitwise AND", test_num);
            op = 3'b011;
            accum = 8'hF0;
            alu_in = 8'hCC;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR (Op 4) - Bitwise XOR", test_num);
            op = 3'b100;
            accum = 8'hAA;
            alu_in = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LDA (Op 5) - Load alu_in to output", test_num);
            op = 3'b101;
            accum = 8'h00;
            alu_in = 8'h88;
            #1;

            check_outputs(8'h88);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: STO (Op 6) - Output accum", test_num);
            op = 3'b110;
            accum = 8'h77;
            alu_in = 8'hEE;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LDO (Op 7) - Load alu_in to output", test_num);
            op = 3'b111;
            accum = 8'h00;
            alu_in = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADD (Op 2) - Overflow handling (8-bit wrap)", test_num);
            op = 3'b010;
            accum = 8'hFF;
            alu_in = 8'h01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR (Op 4) - Self XOR result zero", test_num);
            op = 3'b100;
            accum = 8'h55;
            alu_in = 8'h55;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_alu_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h",
                         alu_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h",
                         expected_alu_out);
                $display("  Got:      alu_out=%h",
                         alu_out);
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
