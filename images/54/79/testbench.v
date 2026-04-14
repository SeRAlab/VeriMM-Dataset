`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [4:0] opcode;
    wire [31:0] resultado;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .resultado(resultado)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'd15;
            b = 32'd25;
            opcode = 5'd0;
            #10;
            $display("Testcase %0d: Addition", test_num);
            #1;

            check_outputs(32'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'd100;
            b = 32'd37;
            opcode = 5'd1;
            #10;
            $display("Testcase %0d: Subtraction", test_num);
            #1;

            check_outputs(32'd63);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'hAAAAAAAA;
            b = 32'hFFFF0000;
            opcode = 5'd2;
            #10;
            $display("Testcase %0d: Bitwise AND", test_num);
            #1;

            check_outputs(32'hAAAA0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'h12340000;
            b = 32'h00005678;
            opcode = 5'd3;
            #10;
            $display("Testcase %0d: Bitwise OR", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'h1;
            b = 32'd4;
            opcode = 5'd4;
            #10;
            $display("Testcase %0d: Left Shift", test_num);
            #1;

            check_outputs(32'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'h80;
            b = 32'd3;
            opcode = 5'd5;
            #10;
            $display("Testcase %0d: Right Shift", test_num);
            #1;

            check_outputs(32'h10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'd12;
            b = 32'd11;
            opcode = 5'd6;
            #10;
            $display("Testcase %0d: Multiplication", test_num);
            #1;

            check_outputs(32'd132);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'd144;
            b = 32'd12;
            opcode = 5'd7;
            #10;
            $display("Testcase %0d: Division", test_num);
            #1;

            check_outputs(32'd12);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            opcode = 5'd31;
            #10;
            $display("Testcase %0d: Zero Case (Default)", test_num);
            #1;

            check_outputs(32'd0);
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
        input [31:0] expected_resultado;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resultado === (expected_resultado ^ resultado ^ expected_resultado)) begin
                $display("PASS");
                $display("  Outputs: resultado=%h",
                         resultado);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resultado=%h",
                         expected_resultado);
                $display("  Got:      resultado=%h",
                         resultado);
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
