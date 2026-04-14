`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] in_data;
    reg [2:0] op_select;
    reg reset_n;
    wire [31:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .in_data(in_data),
        .op_select(op_select),
        .reset_n(reset_n),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            enable = 0;
            in_data = 0;
            op_select = 0;
            @(posedge clk);
            #1;
            reset_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset check...");
            reset_dut();
            test_num = 1;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition check...");
            reset_dut();
            test_num = 2;
            in_data = 32'd150;
            op_select = OP_ADD;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd150);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Subtraction check...");
            reset_dut();
            test_num = 3;
            in_data = 32'd50;
            op_select = OP_SUB;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-32'd50);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiplication check...");
            reset_dut();
            test_num = 4;

            in_data = 32'd10;
            op_select = OP_ADD;
            enable = 1;
            @(posedge clk);

            #1 in_data = 32'd5;
            op_select = OP_MUL;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Division check...");
            reset_dut();
            test_num = 5;

            in_data = 32'd100;
            op_select = OP_ADD;
            enable = 1;
            @(posedge clk);

            #1 in_data = 32'd4;
            op_select = OP_DIV;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd25);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Logical AND check...");
            reset_dut();
            test_num = 6;

            in_data = 32'hFFFFFFFF;
            op_select = OP_ADD;
            enable = 1;
            @(posedge clk);

            #1 in_data = 32'h0F0F0F0F;
            op_select = OP_AND;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0F0F0F0F);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Logical OR check...");
            reset_dut();
            test_num = 7;

            in_data = 32'hAAAA0000;
            op_select = OP_ADD;
            enable = 1;
            @(posedge clk);

            #1 in_data = 32'h00005555;
            op_select = OP_OR;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Logical XOR check...");
            reset_dut();
            test_num = 8;

            in_data = 32'hAAAAAAAA;
            op_select = OP_ADD;
            enable = 1;
            @(posedge clk);

            #1 in_data = 32'hFFFFFFFF;
            op_select = OP_XOR;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Logical NOT check...");
            reset_dut();
            test_num = 9;
            in_data = 32'h0000FFFF;
            op_select = OP_NOT;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Enable control check...");
            reset_dut();
            test_num = 10;
            in_data = 32'd99;
            op_select = OP_ADD;
            enable = 0;
            @(posedge clk);
            #1;
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
        input [31:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, enable, in_data, op_select, reset_n, out_data);
    end

endmodule
