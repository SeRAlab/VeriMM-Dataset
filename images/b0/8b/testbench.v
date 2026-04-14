`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] t;
    wire [4:0] eta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .t(t),
        .eta(eta)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            t = 0;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB=1, bits[14:13]=00, t[12:0]=0", test_num);
            reset_dut();
            t = 16'h8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB=1, bits[14:13]=01, t[12:0]=0", test_num);
            reset_dut();
            t = 16'hA000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB=1, bits[14:13]=10, t[12:0]=0", test_num);
            reset_dut();
            t = 16'hC000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB=1, bits[14:13]=11, t[12:0]=0", test_num);
            reset_dut();
            t = 16'hE000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB=0, Base Value path, t[12:0]=0", test_num);
            reset_dut();
            t = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd17);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB=1, t[12:0]=1500", test_num);
            reset_dut();
            t = 16'h85DC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB=1, t[12:0]=4000", test_num);
            reset_dut();
            t = 16'h8FA0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB=0, t[12:0]=1500", test_num);
            reset_dut();
            t = 16'h05DC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd18);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB=0, t[12:0]=4000", test_num);
            reset_dut();
            t = 16'h0FA0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd19);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits high (0xFFFF)", test_num);
            reset_dut();
            t = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd15);
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
        input [4:0] expected_eta;
        begin
            if (expected_eta === (expected_eta ^ eta ^ expected_eta)) begin
                $display("PASS");
                $display("  Outputs: eta=%h",
                         eta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eta=%h",
                         expected_eta);
                $display("  Got:      eta=%h",
                         eta);
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
        $dumpvars(0,clk, reset, t, eta);
    end

endmodule
