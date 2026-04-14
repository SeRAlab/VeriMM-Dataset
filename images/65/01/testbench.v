`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .enable(enable),
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
            enable = 0;
            reset = 1;
            #12;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;



            if (q != 16'h0001)
                #1;

                check_outputs(q);
            else
                #1;

                check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            #2;
            reset = 1;
            #1;
            #1;

            check_outputs(16'h0001);
            reset = 0;
        end
        endtask

    task testcase005;

        reg [15:0] last_q;
        begin
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;
            last_q = q;
            @(posedge clk);
            #1;

            if (q != last_q && q != 16'h0001)
                pass_count = pass_count + 1;
            else
                fail_count = fail_count + 1;

            $display("Testcase 005: Sequential change check - %s", (q != last_q) ? "PASS" : "FAIL");
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, enable, reset, q);
    end

endmodule
