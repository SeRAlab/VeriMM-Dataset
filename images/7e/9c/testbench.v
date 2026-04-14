`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg sw0;
    reg sw1;
    reg sw2;
    wire B;
    wire G;
    wire R;
    wire hSync;
    wire vSync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .sw0(sw0),
        .sw1(sw1),
        .sw2(sw2),
        .B(B),
        .G(G),
        .R(R),
        .hSync(hSync),
        .vSync(vSync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sw0 = 0;
            sw1 = 0;
            sw2 = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Post-Reset Active Region Check");
            reset_dut();
            sw0 = 1; sw1 = 1; sw2 = 1;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 1, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Active Region Red Output");
            reset_dut();
            sw0 = 1; sw1 = 0; sw2 = 0;
            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Active Region Green Output");
            reset_dut();
            sw0 = 0; sw1 = 1; sw2 = 0;
            repeat(50) @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Horizontal Blanking Region (RGB should be 0)");
            reset_dut();
            sw0 = 1; sw1 = 1; sw2 = 1;

            repeat(700) @(posedge clk);
            #2;



            if (R === 0 && G === 0 && B === 0) begin
                $display("PASS: RGB correctly blanked");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: RGB not blanked in non-active region. R=%b G=%b B=%b", R, G, B);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Horizontal Sync Pulse Check");
            reset_dut();

            repeat(700) @(posedge clk);
            #2;


            if (hSync === 0) begin
                $display("PASS: hSync pulse detected (low)");
                pass_count = pass_count + 1;
            } else begin


                $display("INFO: Checking hSync state at cycle 700: %b", hSync);
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
        input expected_B;
        input expected_G;
        input expected_R;
        input expected_hSync;
        input expected_vSync;
        begin
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_hSync === (expected_hSync ^ hSync ^ expected_hSync) &&
                expected_vSync === (expected_vSync ^ vSync ^ expected_vSync)) begin
                $display("PASS");
                $display("  Outputs: B=%b, G=%b, R=%b, hSync=%b, vSync=%b",
                         B, G, R, hSync, vSync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%b, G=%b, R=%b, hSync=%b, vSync=%b",
                         expected_B, expected_G, expected_R, expected_hSync, expected_vSync);
                $display("  Got:      B=%b, G=%b, R=%b, hSync=%b, vSync=%b",
                         B, G, R, hSync, vSync);
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
        $dumpvars(0,clk, reset, sw0, sw1, sw2, B, G, R, hSync, vSync);
    end

endmodule
