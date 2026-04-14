`timescale 1ns/1ps

module sign_extend_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] reg_in;
    reg reset;
    wire [31:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sign_extend dut (
        .clk(clk),
        .reg_in(reg_in),
        .reset(reset),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            reg_in = 16'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            reg_in = 16'd10;
            @(posedge clk);
            #2;
            $display("Test Case 001: reg_in = 10");
            #1;

            check_outputs(32'h0000000A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            reg_in = 16'd15;
            @(posedge clk);
            #2;
            $display("Test Case 002: reg_in = 15");
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            reg_in = -16'sd20;
            @(posedge clk);
            #2;
            $display("Test Case 003: reg_in = -20");
            #1;

            check_outputs(32'hFFFFFFEC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            reg_in = 16'd50;
            @(posedge clk);
            #2;
            $display("Test Case 004: reg_in = 50");
            #1;

            check_outputs(32'h00000032);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            reg_in = 16'sh8000;
            @(posedge clk);
            #2;
            $display("Test Case 005: reg_in = -32768");
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            reg_in = 16'sh7FFF;
            @(posedge clk);
            #2;
            $display("Test Case 006: reg_in = 32767");
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            reg_in = 16'd0;
            @(posedge clk);
            #2;
            $display("Test Case 007: reg_in = 0");
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            reg_in = 16'd1;
            @(posedge clk);
            #2;
            $display("Test Case 008: reg_in = 1");
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            reg_in = -16'sd1;
            @(posedge clk);
            #2;
            $display("Test Case 009: reg_in = -1");
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
        $display("sign_extend Testbench");
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
        input [31:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, reg_in, reset, reg_out);
    end

endmodule
