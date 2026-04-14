`timescale 1ns/1ps

module memidxrng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [3:0] in_num;
    reg rst;
    wire [2:0] out_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memidxrng dut (
        .clk(clk),
        .en(en),
        .in_num(in_num),
        .rst(rst),
        .out_num(out_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            in_num = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Enable Low");
            reset_dut();
            en = 0;
            in_num = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Range 0 - Input 0");
            reset_dut();
            en = 1;
            in_num = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Range 0 - Input 5 (Example)");
            reset_dut();
            en = 1;
            in_num = 4'b0101;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Range 0 - Input 7");
            reset_dut();
            en = 1;
            in_num = 4'b0111;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Range 1 - Input 8");
            reset_dut();
            en = 1;
            in_num = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Range 1 - Input 15");
            reset_dut();
            en = 1;
            in_num = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset while active");
            reset_dut();
            en = 1;
            in_num = 4'b1111;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Enable toggling");
            reset_dut();
            en = 1;
            in_num = 4'b1010;
            @(posedge clk);
            #1;
            en = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memidxrng Testbench");
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
        input [2:0] expected_out_num;
        begin
            if (expected_out_num === (expected_out_num ^ out_num ^ expected_out_num)) begin
                $display("PASS");
                $display("  Outputs: out_num=%h",
                         out_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_num=%h",
                         expected_out_num);
                $display("  Got:      out_num=%h",
                         out_num);
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
        $dumpvars(0,clk, en, in_num, rst, out_num);
    end

endmodule
