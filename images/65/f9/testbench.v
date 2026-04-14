`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] ctrl;
    wire [31:0] y;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .y(y),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            ctrl = 3'b000;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            ctrl = 3'b001;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition", test_num);
            a = 32'd100;
            b = 32'd250;
            ctrl = 3'b010;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (zero result)", test_num);
            a = 32'd100;
            b = -32'd100;
            ctrl = 3'b010;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction", test_num);
            a = 32'd500;
            b = 32'd200;
            ctrl = 3'b110;
            #1;

            check_outputs(32'd300, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (zero result)", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;
            ctrl = 3'b110;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Check (a < b)", test_num);
            a = 32'd10;
            b = 32'd20;
            ctrl = 3'b111;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Check (a > b)", test_num);
            a = 32'd20;
            b = 32'd10;
            ctrl = 3'b111;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with wrap-around", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0001;
            ctrl = 3'b010;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (negative result)", test_num);
            a = 32'd5;
            b = 32'd10;
            ctrl = 3'b110;

            #1;


            check_outputs(32'hFFFF_FFFB, 1'b0);
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
        input [31:0] expected_y;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: y=%h, zero=%b",
                         y, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h, zero=%b",
                         expected_y, expected_zero);
                $display("  Got:      y=%h, zero=%b",
                         y, zero);
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
