`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    reg [1:0] mode;
    reg [4:0] shift_amt;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .mode(mode),
        .shift_amt(shift_amt),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 32'h00000001;
            shift_amt = 5'd1;
            mode = 2'd2;
            $display("Testcase %0d: LSL 1 bit", test_num);
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 32'h0000FFFF;
            shift_amt = 5'd16;
            mode = 2'd2;
            $display("Testcase %0d: LSL 16 bits", test_num);
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 32'h80000000;
            shift_amt = 5'd1;
            mode = 2'd1;
            $display("Testcase %0d: LSR 1 bit", test_num);
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 32'hFFFFFFFF;
            shift_amt = 5'd8;
            mode = 2'd1;
            $display("Testcase %0d: LSR 8 bits", test_num);
            #1;

            check_outputs(32'h00FFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 32'h70000000;
            shift_amt = 5'd4;
            mode = 2'd0;
            $display("Testcase %0d: ASR Positive Number", test_num);
            #1;

            check_outputs(32'h07000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 32'h80000000;
            shift_amt = 5'd1;
            mode = 2'd0;
            $display("Testcase %0d: ASR Negative Number (Sign extension check)", test_num);
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 32'h80000000;
            shift_amt = 5'd31;
            mode = 2'd0;
            $display("Testcase %0d: ASR Max bits Negative", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 32'hA5A5A5A5;
            shift_amt = 5'd0;
            mode = 2'd2;
            $display("Testcase %0d: Zero Shift LSL", test_num);
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 32'hFFFFFFFF;
            shift_amt = 5'd31;
            mode = 2'd2;
            $display("Testcase %0d: LSL 31 bits", test_num);
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 32'hFFFFFFFF;
            shift_amt = 5'd16;
            mode = 2'd0;
            $display("Testcase %0d: ASR 16 bits on all ones", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
