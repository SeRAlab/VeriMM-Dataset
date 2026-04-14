`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] I;
    reg clk;
    wire EN;
    wire [2:0] Q;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .clk(clk),
        .EN(EN),
        .Q(Q),
        .V(V)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            I = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task drive_input;

        input [7:0] val;
        begin
            I = val;
            if (val != 8'b0) begin
                expected_v_state = ~expected_v_state;
            end
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Highest bit set (I[7])", test_num);
        drive_input(8'b1000_0000);
        #1;

        check_outputs(1'b1, 3'd7, expected_v_state);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Lowest bit set (I[0])", test_num);
        drive_input(8'b0000_0001);
        #1;

        check_outputs(1'b1, 3'd0, expected_v_state);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Priority check (I[7] and I[0])", test_num);
        drive_input(8'b1000_0001);
        #1;

        check_outputs(1'b1, 3'd7, expected_v_state);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Middle bit (I[4])", test_num);
        drive_input(8'b0001_0000);
        #1;

        check_outputs(1'b1, 3'd4, expected_v_state);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Priority check (I[5], I[3], I[2])", test_num);
        drive_input(8'b0010_1100);
        #1;

        check_outputs(1'b1, 3'd5, expected_v_state);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: All bits active", test_num);
        drive_input(8'hFF);
        #1;

        check_outputs(1'b1, 3'd7, expected_v_state);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test %0d: Zero input (No active bits)", test_num);
        drive_input(8'h00);
        #1;

        check_outputs(1'b0, Q, expected_v_state);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Test %0d: Consecutive valid inputs (Verify V toggles back)", test_num);
        drive_input(8'h80);
        drive_input(8'h01);
        #1;

        check_outputs(1'b1, 3'd0, expected_v_state);
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
        input expected_EN;
        input [2:0] expected_Q;
        input expected_V;
        begin
            if (expected_EN === (expected_EN ^ EN ^ expected_EN) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: EN=%b, Q=%h, V=%b",
                         EN, Q, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%b, Q=%h, V=%b",
                         expected_EN, expected_Q, expected_V);
                $display("  Got:      EN=%b, Q=%h, V=%b",
                         EN, Q, V);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,I, clk, EN, Q, V);
    end

endmodule
