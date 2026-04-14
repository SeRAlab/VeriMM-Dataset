`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    reg [1:0] sel;
    reg [4:0] shift_amt;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sel(sel),
        .shift_amt(shift_amt),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 8'hA5;
            sel = 2'b00;
            shift_amt = 5'd0;
            $display("Testcase %0d: Logical Left Shift by 0", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 8'h55;
            sel = 2'b00;
            shift_amt = 5'd1;
            $display("Testcase %0d: Logical Left Shift by 1", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 8'h0F;
            sel = 2'b00;
            shift_amt = 5'd4;
            $display("Testcase %0d: Logical Left Shift by 4", test_num);
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 8'hFF;
            sel = 2'b00;
            shift_amt = 5'd8;
            $display("Testcase %0d: Logical Left Shift overflow (by 8)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 8'hA5;
            sel = 2'b01;
            shift_amt = 5'd0;
            $display("Testcase %0d: Logical Right Shift by 0", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 8'hAA;
            sel = 2'b01;
            shift_amt = 5'd1;
            $display("Testcase %0d: Logical Right Shift by 1", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 8'hF0;
            sel = 2'b01;
            shift_amt = 5'd4;
            $display("Testcase %0d: Logical Right Shift by 4", test_num);
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 8'hFF;
            sel = 2'b01;
            shift_amt = 5'd8;
            $display("Testcase %0d: Logical Right Shift overflow (by 8)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 8'h40;
            sel = 2'b10;
            shift_amt = 5'd1;
            $display("Testcase %0d: Arithmetic Right Shift (Positive) by 1", test_num);
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 8'h80;
            sel = 2'b10;
            shift_amt = 5'd1;
            $display("Testcase %0d: Arithmetic Right Shift (Negative) by 1", test_num);
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            in = 8'hF0;
            sel = 2'b10;
            shift_amt = 5'd4;
            $display("Testcase %0d: Arithmetic Right Shift (Negative) by 4", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            in = 8'h80;
            sel = 2'b10;
            shift_amt = 5'd31;
            $display("Testcase %0d: Arithmetic Right Shift max shift (sign extension check)", test_num);
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_out;
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
