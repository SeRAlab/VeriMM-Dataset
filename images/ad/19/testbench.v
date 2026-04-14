`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CC;
    reg [7:0] a;
    reg [7:0] b;
    reg c;
    reg [1:0] opControl;
    wire [2:0] czn;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CC(CC),
        .a(a),
        .b(b),
        .c(c),
        .opControl(opControl),
        .czn(czn),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Addition (1 + 2)", test_num);
            a = 8'd1;
            b = 8'd2;
            c = 1'b0;
            opControl = 2'b00;
            CC = 1'b0;
            #1;

            check_outputs(3'b000, 8'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Carry-In (10 + 20 + 1)", test_num);
            a = 8'd10;
            b = 8'd20;
            c = 1'b1;
            opControl = 2'b00;
            CC = 1'b0;
            #1;

            check_outputs(3'b000, 8'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Overflow - Carry and Zero Flags (255 + 1)", test_num);
            a = 8'hFF;
            b = 8'h01;
            c = 1'b0;
            opControl = 2'b00;
            CC = 1'b0;

            #1;


            check_outputs(3'b110, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Negative Flag (128 + 1)", test_num);
            a = 8'h80;
            b = 8'h01;
            c = 1'b0;
            opControl = 2'b00;
            CC = 1'b0;

            #1;


            check_outputs(3'b001, 8'h81);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND - Zero Flag", test_num);
            a = 8'hAA;
            b = 8'h55;
            c = 1'b0;
            opControl = 2'b01;
            CC = 1'b0;

            #1;


            check_outputs(3'b010, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND - Negative Flag", test_num);
            a = 8'hF0;
            b = 8'h80;
            c = 1'b0;
            opControl = 2'b01;
            CC = 1'b0;

            #1;


            check_outputs(3'b001, 8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR - Normal", test_num);
            a = 8'h0F;
            b = 8'hF0;
            c = 1'b0;
            opControl = 2'b10;
            CC = 1'b0;

            #1;


            check_outputs(3'b001, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR - Zero Flag", test_num);
            a = 8'h00;
            b = 8'h00;
            c = 1'b0;
            opControl = 2'b10;
            CC = 1'b0;

            #1;


            check_outputs(3'b010, 8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Addition (255 + 255 + 1)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            c = 1'b1;
            opControl = 2'b00;
            CC = 1'b0;

            #1;


            check_outputs(3'b101, 8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition Resulting in Zero with Carry-In", test_num);
            a = 8'hFE;
            b = 8'h01;
            c = 1'b1;
            opControl = 2'b00;
            CC = 1'b0;

            #1;


            check_outputs(3'b110, 8'h00);
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
        input [2:0] expected_czn;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_czn === (expected_czn ^ czn ^ expected_czn) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: czn=%h, result=%h",
                         czn, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: czn=%h, result=%h",
                         expected_czn, expected_result);
                $display("  Got:      czn=%h, result=%h",
                         czn, result);
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
