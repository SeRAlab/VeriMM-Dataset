`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] sel;
    wire [7:0] f;
    wire ovf;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .f(f),
        .ovf(ovf),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd10; b = 8'd20; sel = 3'b000;
            #1;

            check_outputs(8'd30, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'h7F; b = 8'h01; sel = 3'b000;
            #1;

            check_outputs(8'h80, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'hFF; b = 8'h01; sel = 3'b000;
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'd50; b = 8'd20; sel = 3'b001;
            #1;

            check_outputs(8'd30, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'h80; b = 8'h01; sel = 3'b001;
            #1;

            check_outputs(8'h7F, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'h42; b = 8'h42; sel = 3'b001;
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'hAA; b = 8'hF0; sel = 3'b010;
            #1;

            check_outputs(8'hA0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'h55; b = 8'hAA; sel = 3'b011;
            #1;

            check_outputs(8'hFF, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 8'hCC; b = 8'hCC; sel = 3'b100;
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 8'h0F; b = 8'hXX; sel = 3'b101;
            #1;

            check_outputs(8'hF0, 1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            a = 8'h01; b = 8'h00; sel = 3'b110;
            #1;

            check_outputs(8'h02, 1'b0, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            a = 8'h80; b = 8'h00; sel = 3'b111;
            #1;

            check_outputs(8'h40, 1'b0, 1'b0);
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
        input [7:0] expected_f;
        input expected_ovf;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f) &&
                expected_ovf === (expected_ovf ^ ovf ^ expected_ovf) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: f=%h, ovf=%b, zero=%b",
                         f, ovf, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h, ovf=%b, zero=%b",
                         expected_f, expected_ovf, expected_zero);
                $display("  Got:      f=%h, ovf=%b, zero=%b",
                         f, ovf, zero);
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
