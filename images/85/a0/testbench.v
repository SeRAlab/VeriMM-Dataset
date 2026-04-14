`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Tj_Trig;
    reg clk;
    reg [127:0] key;
    reg rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Tj_Trig(Tj_Trig),
        .clk(clk),
        .key(key),
        .rst(rst)
    );

    // Clock generation (10ns period)
    initial begin
        Tj_Trig = 0;
        forever #5 Tj_Trig = ~Tj_Trig;
    end

        task reset_dut;

        begin
            rst = 1;
            Tj_Trig = 0;
            key = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Load and Shift...");
            reset_dut();
            load_key(128'hA);



            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multi-cycle shifting...");
            reset_dut();
            load_key(128'hF0);


            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(128'h0F);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Trigger sensitivity...");
            reset_dut();
            key = 128'hDEADBEEF;
            Tj_Trig = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(128'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: All-ones shift...");
            reset_dut();
            load_key({128{1'b1}});

            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs({1'b0, {127{1'b1}}});
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset mid-process...");
            reset_dut();
            load_key(128'hFFFF_FFFF);
            repeat(5) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #1;

            check_outputs(128'h0);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,Tj_Trig, clk, key, rst);
    end

endmodule
