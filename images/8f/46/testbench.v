`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] control;
    wire [31:0] alu_res;
    wire of;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .control(control),
        .alu_res(alu_res),
        .of(of)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise AND", test_num);
            control = 3'b000;
            a = 32'hAAAA_AAAA;
            b = 32'hFFFF_0000;

            #1;


            check_outputs(32'hAAAA_0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise OR", test_num);
            control = 3'b001;
            a = 32'h1234_5678;
            b = 32'h8765_4321;
            #1;

            check_outputs(32'h9775_5779, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (Normal)", test_num);
            control = 3'b010;
            a = 32'd100;
            b = 32'd250;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (Overflow Positive)", test_num);
            control = 3'b010;
            a = 32'h7FFF_FFFF;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'h8000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (Normal)", test_num);
            control = 3'b011;
            a = 32'd500;
            b = 32'd100;
            #1;

            check_outputs(32'd400, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (Overflow Negative)", test_num);
            control = 3'b011;
            a = 32'h8000_0000;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'h7FFF_FFFF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise XOR", test_num);
            control = 3'b100;
            a = 32'hF0F0_F0F0;
            b = 32'hAAAA_AAAA;
            #1;

            check_outputs(32'h5A5A_5A5A, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise NOR", test_num);
            control = 3'b101;
            a = 32'h0000_FFFF;
            b = 32'h0000_0000;
            #1;

            check_outputs(32'hFFFF_0000, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLT (Signed Less Than - True)", test_num);
            control = 3'b110;
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLT (Signed Less Than - False)", test_num);
            control = 3'b110;
            a = 32'h0000_0001;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLTU (Unsigned Less Than - True)", test_num);
            control = 3'b111;
            a = 32'h0000_0001;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SLTU (Unsigned Less Than - False)", test_num);
            control = 3'b111;
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000, 1'b0);
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
        input [31:0] expected_alu_res;
        input expected_of;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_res === (expected_alu_res ^ alu_res ^ expected_alu_res) &&
                expected_of === (expected_of ^ of ^ expected_of)) begin
                $display("PASS");
                $display("  Outputs: alu_res=%h, of=%b",
                         alu_res, of);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_res=%h, of=%b",
                         expected_alu_res, expected_of);
                $display("  Got:      alu_res=%h, of=%b",
                         alu_res, of);
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
