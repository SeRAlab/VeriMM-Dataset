`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [7:0] in;
    reg [7:0] shift_amt;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in(in),
        .shift_amt(shift_amt),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift - Basic (in=8'hA5, amt=1)", test_num);
            ctrl = 2'b00;
            in = 8'hA5;
            shift_amt = 8'd1;
            #1;

            check_outputs(8'h4A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift - Large (in=8'h0F, amt=4)", test_num);
            ctrl = 2'b00;
            in = 8'h0F;
            shift_amt = 8'd4;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Right Shift - Basic (in=8'hAC, amt=2)", test_num);
            ctrl = 2'b01;
            in = 8'hAC;
            shift_amt = 8'd2;
            #1;

            check_outputs(8'h2B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Right Shift - Clear (in=8'hFF, amt=8)", test_num);
            ctrl = 2'b01;
            in = 8'hFF;
            shift_amt = 8'd8;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift - Positive (in=8'h40, amt=2)", test_num);
            ctrl = 2'b10;
            in = 8'h40;
            shift_amt = 8'd2;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift - Negative Sign Extension (in=8'h80, amt=1)", test_num);
            ctrl = 2'b10;
            in = 8'h80;
            shift_amt = 8'd1;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift - Negative Saturation (in=8'hF0, amt=4)", test_num);
            ctrl = 2'b10;
            in = 8'hF0;
            shift_amt = 8'd4;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Shift (in=8'h5A, amt=0)", test_num);
            ctrl = 2'b00;
            in = 8'h5A;
            shift_amt = 8'd0;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Beyond Width (in=8'hFF, amt=10)", test_num);
            ctrl = 2'b00;
            in = 8'hFF;
            shift_amt = 8'd10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arithmetic Right Shift Beyond Width (in=8'h81, amt=10)", test_num);
            ctrl = 2'b10;
            in = 8'h81;
            shift_amt = 8'd10;
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
