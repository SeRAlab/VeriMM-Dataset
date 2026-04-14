`timescale 1ns/1ps

module reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_8bit dut (
        .clk(clk),
        .d(d),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        load = 0;
        d = 8'h00;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase001: Verifying synchronous reset...");
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase002: Loading 0xAA...");
        reset_dut();
        @(negedge clk);
        load = 1;
        d = 8'hAA;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase003: Verifying hold behavior (load=0)...");
        reset_dut();

        @(negedge clk);
        load = 1;
        d = 8'h55;
        @(negedge clk);

        load = 0;
        d = 8'hFF;
        @(negedge clk);

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase004: Verifying reset priority over load...");
        reset_dut();
        @(negedge clk);
        reset = 1;
        load = 1;
        d = 8'hEE;
        @(negedge clk);
        reset = 0;
        load = 0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase005: Loading 0xFF...");
        reset_dut();
        @(negedge clk);
        load = 1;
        d = 8'hFF;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_8bit Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, d, load, reset, q);
    end

endmodule
