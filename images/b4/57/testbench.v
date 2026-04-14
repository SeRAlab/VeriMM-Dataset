`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] iline;
    reg [1:0] rw;
    wire [15:0] oline;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .iline(iline),
        .rw(rw),
        .oline(oline)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rw = 2'b00;
            iline = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Writing 16'hABCD...", test_num);
            rw = 2'b01;
            iline = 16'hABCD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Hold value after writing...", test_num);

            rw = 2'b01;
            iline = 16'h55AA;
            @(posedge clk);
            #1;

            rw = 2'b10;
            iline = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Clear register after writing...", test_num);

            rw = 2'b01;
            iline = 16'hFFFF;
            @(posedge clk);
            #1;

            rw = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Successive writes...", test_num);
            rw = 2'b01;
            iline = 16'h1234;
            @(posedge clk);
            #1;
            iline = 16'h8765;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8765);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Data stability in Read mode...", test_num);
            rw = 2'b01;
            iline = 16'hC0DE;
            @(posedge clk);
            #1;
            rw = 2'b10;
            iline = 16'h0000;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hC0DE);
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
        input [15:0] expected_oline;
        begin
            if (expected_oline === (expected_oline ^ oline ^ expected_oline)) begin
                $display("PASS");
                $display("  Outputs: oline=%h",
                         oline);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oline=%h",
                         expected_oline);
                $display("  Got:      oline=%h",
                         oline);
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
        $dumpvars(0,clk, iline, rw, oline);
    end

endmodule
