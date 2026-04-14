`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .reset(reset),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verify LFSR initializes to 32'h1 after reset");
            reset_dut();
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Verify LFSR shifts once (expecting 2)");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify LFSR after 12 clock cycles (Initial '1' at bit 12)");
            reset_dut();
            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00001000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify feedback after 13 cycles (x^13 tap triggers)");
            reset_dut();
            repeat(13) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00002001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify feedback after 17 cycles (x^17 tap triggers)");
            reset_dut();
            repeat(17) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00020011);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify feedback after 22 cycles (x^22 tap triggers)");
            reset_dut();
            repeat(22) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00400221);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Verify feedback after 32 cycles (Initial '1' shifts out)");
            reset_dut();
            repeat(32) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00088401);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_32bit Testbench");
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
        input [31:0] expected_lfsr_out;
        begin
            if (expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: lfsr_out=%h",
                         lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr_out=%h",
                         expected_lfsr_out);
                $display("  Got:      lfsr_out=%h",
                         lfsr_out);
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
        $dumpvars(0,clk, reset, lfsr_out);
    end

endmodule
