`timescale 1ns/1ps

module alu_32bit_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] alu_ctrl;
    reg clk;
    reg [31:0] data_a;
    reg [31:0] data_b;
    reg en;
    reg reset;
    wire [31:0] alu_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_32bit dut (
        .alu_ctrl(alu_ctrl),
        .clk(clk),
        .data_a(data_a),
        .data_b(data_b),
        .en(en),
        .reset(reset),
        .alu_out(alu_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            data_a = 0;
            data_b = 0;
            alu_ctrl = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Addition (32'd100 + 32'd200)");
            reset_dut();
            @(negedge clk);
            en = 1;
            alu_ctrl = 3'b000;
            data_a = 32'd100;
            data_b = 32'd200;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd300);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Subtraction (32'd500 - 32'd150)");
            reset_dut();
            @(negedge clk);
            en = 1;
            alu_ctrl = 3'b001;
            data_a = 32'd500;
            data_b = 32'd150;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Bitwise AND (0xF0F0F0F0 & 0xAAAA0000)");
            reset_dut();
            @(negedge clk);
            en = 1;
            alu_ctrl = 3'b010;
            data_a = 32'hF0F0F0F0;
            data_b = 32'hAAAA0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hA0A00000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bitwise OR (0x0000FFFF | 0xFFFF0000)");
            reset_dut();
            @(negedge clk);
            en = 1;
            alu_ctrl = 3'b011;
            data_a = 32'h0000FFFF;
            data_b = 32'hFFFF0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise XOR (0x12345678 ^ 0x12345678)");
            reset_dut();
            @(negedge clk);
            en = 1;
            alu_ctrl = 3'b100;
            data_a = 32'h12345678;
            data_b = 32'h12345678;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enable Signal (en=0, inputs changing)");
            reset_dut();
            @(negedge clk);
            en = 0;
            alu_ctrl = 3'b000;
            data_a = 32'hFFFFFFFF;
            data_b = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Subtraction (10 - 20 = -10)");
            reset_dut();
            @(negedge clk);
            en = 1;
            alu_ctrl = 3'b001;
            data_a = 32'd10;
            data_b = 32'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_32bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_alu_out;
        begin
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h",
                         alu_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h",
                         expected_alu_out);
                $display("  Got:      alu_out=%h",
                         alu_out);
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
        $dumpvars(0,alu_ctrl, clk, data_a, data_b, en, reset, alu_out);
    end

endmodule
