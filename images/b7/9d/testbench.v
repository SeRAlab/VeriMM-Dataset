`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] sel;
    wire [7:0] f;
    wire ovf;
    wire take_branch;

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
        .take_branch(take_branch)
    );
    task testcase001;

        begin
            test_num = 1;
            sel = 3'b000; a = 8'd10; b = 8'd20;
            #1;

            check_outputs(8'd30, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            sel = 3'b000; a = 8'h7F; b = 8'h01;
            #1;

            check_outputs(8'h80, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            sel = 3'b000; a = 8'h80; b = 8'hFF;
            #1;

            check_outputs(8'h7F, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            sel = 3'b001; a = 8'b10101010; b = 8'h00;
            #1;

            check_outputs(8'b01010101, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            sel = 3'b010; a = 8'hFF; b = 8'h0F;
            #1;

            check_outputs(8'h0F, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            sel = 3'b011; a = 8'hF0; b = 8'h0F;
            #1;

            check_outputs(8'hFF, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            sel = 3'b100; a = 8'b00001111; b = 8'h00;
            #1;

            check_outputs(8'b00011110, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            sel = 3'b101; a = 8'b10000000; b = 8'h00;
            #1;

            check_outputs(8'b01000000, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            sel = 3'b110; a = 8'd42; b = 8'd42;
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            sel = 3'b110; a = 8'd42; b = 8'd43;
            #1;

            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            sel = 3'b111; a = 8'd42; b = 8'd43;
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            sel = 3'b111; a = 8'd42; b = 8'd42;
            #1;

            check_outputs(8'h00, 1'b0, 1'b0);
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
        input expected_take_branch;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f) &&
                expected_ovf === (expected_ovf ^ ovf ^ expected_ovf) &&
                expected_take_branch === (expected_take_branch ^ take_branch ^ expected_take_branch)) begin
                $display("PASS");
                $display("  Outputs: f=%h, ovf=%b, take_branch=%b",
                         f, ovf, take_branch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h, ovf=%b, take_branch=%b",
                         expected_f, expected_ovf, expected_take_branch);
                $display("  Got:      f=%h, ovf=%b, take_branch=%b",
                         f, ovf, take_branch);
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
