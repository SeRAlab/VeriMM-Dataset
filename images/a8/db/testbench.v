`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg LOAD;
    reg SHL;
    reg SHR;
    reg clk;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .LOAD(LOAD),
        .SHL(SHL),
        .SHR(SHR),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            LOAD = 1;
            D = 4'b0000;
            SHL = 0;
            SHR = 0;
            @(posedge clk);
            #1;
            LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Load data 1010");
            test_num = test_num + 1;
            LOAD = 1;
            D = 4'b1010;
            @(posedge clk);
            #1;
            LOAD = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Shift Left once (1111 -> 1110)");
            test_num = test_num + 1;

            LOAD = 1;
            D = 4'b1111;
            @(posedge clk);
            #1;

            LOAD = 0;
            SHL = 1;
            @(posedge clk);
            #1;
            SHL = 0;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Shift Right once (1111 -> 0111)");
            test_num = test_num + 1;

            LOAD = 1;
            D = 4'b1111;
            @(posedge clk);
            #1;

            LOAD = 0;
            SHR = 1;
            @(posedge clk);
            #1;
            SHR = 0;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Shift Left twice (0001 -> 0100)");
            test_num = test_num + 1;

            LOAD = 1;
            D = 4'b0001;
            @(posedge clk);
            #1;

            LOAD = 0;
            SHL = 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;
            SHL = 0;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Shift Right twice (1000 -> 0010)");
            test_num = test_num + 1;

            LOAD = 1;
            D = 4'b1000;
            @(posedge clk);
            #1;

            LOAD = 0;
            SHR = 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;
            SHR = 0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Shift Left until empty (1000 -> 0000)");
            test_num = test_num + 1;
            LOAD = 1; D = 4'b1000;
            @(posedge clk);
            #1;
            LOAD = 0; SHL = 1;
            repeat(4) @(posedge clk);
            #1;
            SHL = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Shift Right until empty (0001 -> 0000)");
            test_num = test_num + 1;
            LOAD = 1; D = 4'b0001;
            @(posedge clk);
            #1;
            LOAD = 0; SHR = 1;
            repeat(4) @(posedge clk);
            #1;
            SHR = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: Mixed SHL and SHR (Load 1011 -> SHL -> SHR -> 0101)");
            test_num = test_num + 1;

            LOAD = 1; D = 4'b1011;
            @(posedge clk);
            #1;

            LOAD = 0; SHL = 1;
            @(posedge clk);
            #1;
            SHL = 0; SHR = 1;

            @(posedge clk);
            #1;
            SHR = 0; SHL = 1;

            @(posedge clk);
            #1;
            SHL = 0; SHR = 1;

            @(posedge clk);
            #1;
            SHR = 0;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            $display("Testcase 009: Hold value (Load 0101, then no control signals)");
            test_num = test_num + 1;
            LOAD = 1; D = 4'b0101;
            @(posedge clk);
            #1;
            LOAD = 0; SHL = 0; SHR = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            $display("Testcase 010: Load priority over SHL");
            test_num = test_num + 1;
            LOAD = 1; D = 4'b1111;
            SHL = 1;
            @(posedge clk);
            #1;
            SHL = 0; LOAD = 0;
            #1;

            check_outputs(4'b1111);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, LOAD, SHL, SHR, clk, Q);
    end

endmodule
