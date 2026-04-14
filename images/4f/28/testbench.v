`timescale 1ns/1ps

module lfsr_12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_12bit dut (
        .clk(clk),
        .en(en),
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
            en = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(12'h001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Logic (Disable) Check", test_num);
            reset_dut();
            en = 0;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(12'h001);
        end
        endtask

    task testcase003;

        reg [11:0] initial_val;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Logic (Transition) Check", test_num);
            reset_dut();
            initial_val = q;
            en = 1;
            @(posedge clk);
            #1;


            if (q !== initial_val) begin
                $display("PASS: LFSR transitioned from %h to %h", initial_val, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: LFSR stuck at %h", initial_val);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Priority over Enable Check", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;


            #1;



            check_outputs(12'h001);
        end
        endtask

    task testcase005;

        integer i;
        reg is_zero;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-cycle Stability Check", test_num);
            reset_dut();
            en = 1;
            is_zero = 0;

            for (i = 0; i < 50; i = i + 1) begin
                @(posedge clk);
                if (q == 12'h000) is_zero = 1;
            end

            #1;
            if (is_zero) begin
                $display("FAIL: LFSR entered illegal state 000");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: LFSR remained active and non-zero");
                pass_count = pass_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_12bit Testbench");
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
        input [11:0] expected_q;
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
        $dumpvars(0,clk, en, reset, q);
    end

endmodule
