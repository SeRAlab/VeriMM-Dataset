`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] abus_out;
    reg [2:0] alu_op;
    reg [31:0] bbus_out;
    wire [31:0] cbus_in;
    wire n;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .abus_out(abus_out),
        .alu_op(alu_op),
        .bbus_out(bbus_out),
        .cbus_in(cbus_in),
        .n(n),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MOVA", test_num);
            abus_out = 32'hA5A5A5A5;
            bbus_out = 32'hFFFFFFFF;
            alu_op   = 3'b000;
            #1;

            check_outputs(32'hA5A5A5A5, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MOVB", test_num);
            abus_out = 32'h0;
            bbus_out = 32'h12345678;
            alu_op   = 3'b001;
            #1;

            check_outputs(32'h12345678, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD (Simple)", test_num);
            abus_out = 32'd100;
            bbus_out = 32'd250;
            alu_op   = 3'b010;
            #1;

            check_outputs(32'd350, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD (Zero result)", test_num);
            abus_out = 32'd0;
            bbus_out = 32'd0;
            alu_op   = 3'b010;
            #1;

            check_outputs(32'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SUB (Positive result)", test_num);
            abus_out = 32'd500;
            bbus_out = 32'd200;
            alu_op   = 3'b011;
            #1;

            check_outputs(32'd300, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SUB (Negative result)", test_num);
            abus_out = 32'd100;
            bbus_out = 32'd200;
            alu_op   = 3'b011;

            #1;


            check_outputs(32'hFFFFFF9C, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MUL", test_num);
            abus_out = 32'd12;
            bbus_out = 32'd11;
            alu_op   = 3'b100;
            #1;

            check_outputs(32'd132, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DIV", test_num);
            abus_out = 32'd100;
            bbus_out = 32'd4;
            alu_op   = 3'b101;
            #1;

            check_outputs(32'd25, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SHL (Shift Left)", test_num);
            abus_out = 32'h0000000F;
            bbus_out = 32'd4;
            alu_op   = 3'b110;
            #1;

            check_outputs(32'h000000F0, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SHR (Shift Right)", test_num);
            abus_out = 32'hF0000000;
            bbus_out = 32'd4;
            alu_op   = 3'b111;
            #1;

            check_outputs(32'h0F000000, 1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ADD (Overflow/Wrap)", test_num);
            abus_out = 32'hFFFFFFFF;
            bbus_out = 32'h00000001;
            alu_op   = 3'b010;
            #1;

            check_outputs(32'h00000000, 1'b0, 1'b1);
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
        input [31:0] expected_cbus_in;
        input expected_n;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cbus_in === (expected_cbus_in ^ cbus_in ^ expected_cbus_in) &&
                expected_n === (expected_n ^ n ^ expected_n) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: cbus_in=%h, n=%b, z=%b",
                         cbus_in, n, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cbus_in=%h, n=%b, z=%b",
                         expected_cbus_in, expected_n, expected_z);
                $display("  Got:      cbus_in=%h, n=%b, z=%b",
                         cbus_in, n, z);
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
