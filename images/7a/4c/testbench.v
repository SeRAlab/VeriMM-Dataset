`timescale 1ns/1ps

module up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg preset;
    reg [13:0] preset_val;
    reg reset;
    wire [13:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter dut (
        .clk(clk),
        .en(en),
        .preset(preset),
        .preset_val(preset_val),
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
            reset = 1;
            en = 0;
            preset = 0;
            preset_val = 0;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(14'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Counting (10 cycles)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(10) @(negedge clk);
            en = 0;

            #1;


            check_outputs(14'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Control (Pause counting)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(5) @(negedge clk);
            en = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(14'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Preset Functionality", test_num);
            reset_dut();
            @(negedge clk);
            preset_val = 14'h1ABC;
            preset = 1;
            @(negedge clk);
            preset = 0;
            #1;

            check_outputs(14'h1ABC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Preset Priority Over Enable", test_num);
            reset_dut();
            @(negedge clk);
            preset_val = 14'h2555;
            preset = 1;
            en = 1;
            @(negedge clk);
            preset = 0;
            en = 0;
            #1;

            check_outputs(14'h2555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rollover (0x3FFF to 0x0000)", test_num);
            reset_dut();
            @(negedge clk);
            preset_val = 14'h3FFF;
            preset = 1;
            @(negedge clk);
            preset = 0;
            en = 1;
            @(negedge clk);
            en = 0;
            #1;

            check_outputs(14'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Preset then Count", test_num);
            reset_dut();
            @(negedge clk);
            preset_val = 14'd100;
            preset = 1;
            @(negedge clk);
            preset = 0;
            en = 1;
            repeat(50) @(negedge clk);
            en = 0;

            #1;


            check_outputs(14'd150);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [13:0] expected_q;
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
        $dumpvars(0,clk, en, preset, preset_val, reset, q);
    end

endmodule
