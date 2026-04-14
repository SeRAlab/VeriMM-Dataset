`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] I1;
    reg I2;
    reg clk;
    reg rd_en;
    wire E;
    wire ENB;
    wire O1;
    wire O2;
    wire [5:0] O3;
    wire [1:0] Q;
    wire empty;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I1(I1),
        .I2(I2),
        .clk(clk),
        .rd_en(rd_en),
        .E(E),
        .ENB(ENB),
        .O1(O1),
        .O2(O2),
        .O3(O3),
        .Q(Q),
        .empty(empty)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            I1 = 6'd0;
            I2 = 1'b0;
            rd_en = 1'b0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 6'h00, 2'b00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            I1 = 6'h2A; I2 = 1'b1;
            @(posedge clk); #1;

            rd_en = 1;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 6'h2A, 2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            repeat(5) begin
                I1 = $random; I2 = $random;
                @(posedge clk); #1;
            end
            rd_en = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 6'h00, 2'b00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            I1 = 6'h01; I2 = 1'b0; @(posedge clk); #1;

            I1 = 6'h02; I2 = 1'b1; @(posedge clk); #1;

            rd_en = 1; @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 6'h01, 2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(32) begin
                I1 = 6'h3F; I2 = 1'b1;
                @(posedge clk); #1;
            end
            rd_en = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 6'h00, 2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            repeat(32) begin
                I1 = 6'h11; I2 = 1'b0;
                @(posedge clk); #1;
            end

            rd_en = 1;
            repeat(32) @(posedge clk);
            #1;
            rd_en = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 6'h11, 2'b00, 1'b1);
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
        input expected_E;
        input expected_ENB;
        input expected_O1;
        input expected_O2;
        input [5:0] expected_O3;
        input [1:0] expected_Q;
        input expected_empty;
        begin
            if (expected_E === (expected_E ^ E ^ expected_E) &&
                expected_ENB === (expected_ENB ^ ENB ^ expected_ENB) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_O2 === (expected_O2 ^ O2 ^ expected_O2) &&
                expected_O3 === (expected_O3 ^ O3 ^ expected_O3) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty)) begin
                $display("PASS");
                $display("  Outputs: E=%b, ENB=%b, O1=%b, O2=%b, O3=%h, Q=%h, empty=%b",
                         E, ENB, O1, O2, O3, Q, empty);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%b, ENB=%b, O1=%b, O2=%b, O3=%h, Q=%h, empty=%b",
                         expected_E, expected_ENB, expected_O1, expected_O2, expected_O3, expected_Q, expected_empty);
                $display("  Got:      E=%b, ENB=%b, O1=%b, O2=%b, O3=%h, Q=%h, empty=%b",
                         E, ENB, O1, O2, O3, Q, empty);
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
        $dumpvars(0,I1, I2, clk, rd_en, E, ENB, O1, O2, O3, Q, empty);
    end

endmodule
