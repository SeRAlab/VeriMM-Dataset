`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg ce;
    reg clk;
    reg [31:0] d;
    reg we;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ce(ce),
        .clk(clk),
        .d(d),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce <= 0;
            we <= 0;
            addr <= 0;
            d <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write/Read at Address 0", test_num);
            reset_dut();


            @(posedge clk);
            addr <= 10'h000;
            d <= 32'hDEADBEEF;
            ce <= 1;
            we <= 1;


            @(posedge clk);
            we <= 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address 1023", test_num);
            reset_dut();


            @(posedge clk);
            addr <= 10'd1023;
            d <= 32'h12345678;
            ce <= 1;
            we <= 1;


            @(posedge clk);
            we <= 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Chip Enable (ce) inhibition test", test_num);
            reset_dut();


            @(posedge clk);
            addr <= 10'd50; d <= 32'hAAAAAAAA; ce <= 1; we <= 1;


            @(posedge clk);
            addr <= 10'd50; d <= 32'hBBBBBBBB; ce <= 0; we <= 1;


            @(posedge clk);
            addr <= 10'd50; ce <= 1; we <= 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable (we) inhibition test", test_num);
            reset_dut();


            @(posedge clk);
            addr <= 10'd100; d <= 32'h55555555; ce <= 1; we <= 1;


            @(posedge clk);
            addr <= 10'd100; d <= 32'hCCCCCCCC; ce <= 1; we <= 0;


            @(posedge clk);
            addr <= 10'd100; ce <= 1; we <= 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwriting memory", test_num);
            reset_dut();

            @(posedge clk);
            addr <= 10'd200; d <= 32'h11111111; ce <= 1; we <= 1;
            @(posedge clk);
            addr <= 10'd200; d <= 32'h22222222; ce <= 1; we <= 1;
            @(posedge clk);
            we <= 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h22222222);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,addr, ce, clk, d, we, q);
    end

endmodule
