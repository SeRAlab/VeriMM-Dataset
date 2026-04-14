`timescale 1ns/1ps

module lfsr_32_bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] init_value;
    reg load;
    reg rst;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32_bit dut (
        .clk(clk),
        .init_value(init_value),
        .load(load),
        .rst(rst),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            init_value = 32'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Reset state check", test_num);
            reset_dut();

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Load initial value check", test_num);
            reset_dut();
            load = 1;
            init_value = 32'hACE0BA11;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(32'hACE0BA11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Single shift without feedback", test_num);
            reset_dut();
            load = 1;
            init_value = 32'h00000001;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Feedback tap x^32 (Bit 31)", test_num);
            reset_dut();
            load = 1;
            init_value = 32'h80000000;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Feedback tap x^22 (Bit 21)", test_num);
            reset_dut();
            load = 1;
            init_value = 32'h00200000;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00400001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Feedback tap x^17 (Bit 16)", test_num);
            reset_dut();
            load = 1;
            init_value = 32'h00010000;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00020001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Feedback tap x^13 (Bit 12)", test_num);
            reset_dut();
            load = 1;
            init_value = 32'h00001000;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00002001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %03d: Multiple feedback taps (31 and 12)", test_num);
            reset_dut();
            load = 1;
            init_value = 32'h80001000;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00002000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_32_bit Testbench");
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
        input [31:0] expected_lfsr_out;
        begin
            if (expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: lfsr_out=%h",
                         lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr_out=%h",
                         expected_lfsr_out);
                $display("  Got:      lfsr_out=%h",
                         lfsr_out);
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
        $dumpvars(0,clk, init_value, load, rst, lfsr_out);
    end

endmodule
