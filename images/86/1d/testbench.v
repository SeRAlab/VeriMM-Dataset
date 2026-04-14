`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg preset;
    reg [3:0] preset_val;
    reg reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
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
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Synchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Preset to 4'hA", test_num);
            reset_dut();
            preset = 1;
            preset_val = 4'hA;
            @(posedge clk);
            #1;
            preset = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Decrement from Preset value", test_num);
            reset_dut();

            preset = 1;
            preset_val = 4'h5;
            @(posedge clk);
            #1;
            preset = 0;

            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Underflow (0000 -> 1111)", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable control (Counter hold)", test_num);
            reset_dut();
            preset = 1;
            preset_val = 4'h7;
            @(posedge clk);
            #1;
            preset = 0;
            en = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset priority over Preset", test_num);
            reset_dut();
            preset = 1;
            preset_val = 4'hC;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            preset = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Preset priority over Enable", test_num);
            reset_dut();
            preset = 1;
            preset_val = 4'h3;
            en = 1;
            @(posedge clk);
            #1;
            preset = 0;
            en = 0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Multiple steps decrement", test_num);
            reset_dut();
            preset = 1;
            preset_val = 4'h9;
            @(posedge clk);
            #1;
            preset = 0;
            en = 1;
            repeat (3) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'h6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
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
        input [3:0] expected_q;
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
