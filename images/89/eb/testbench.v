`timescale 1ns/1ps

module loadable_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [9:0] D;
    reg EN;
    reg LOAD;
    reg RST;
    wire [9:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    loadable_counter dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .LOAD(LOAD),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            EN = 0;
            LOAD = 0;
            D = 0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Synchronous Reset");
            reset_dut();
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load 10'h1A5");
            reset_dut();
            D = 10'h1A5;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(10'h1A5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simple Counting (5 cycles)");
            reset_dut();
            EN = 1;
            repeat(5) @(posedge CLK);
            #1;
            EN = 0;
            #1;

            check_outputs(10'h005);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable Low (Hold value)");
            reset_dut();
            EN = 1;
            repeat(3) @(posedge CLK);
            EN = 0;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(10'h003);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load then Increment");
            reset_dut();
            D = 10'h0FE;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            EN = 1;
            repeat(2) @(posedge CLK);
            #1;
            EN = 0;
            #1;

            check_outputs(10'h100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Priority over Load");
            reset_dut();
            D = 10'h3FF;
            LOAD = 1;
            RST = 1;
            @(posedge CLK);
            #1;
            RST = 0;
            LOAD = 0;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Load Priority over Enable");
            reset_dut();
            D = 10'h0AA;
            LOAD = 1;
            EN = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            EN = 0;
            #1;

            check_outputs(10'h0AA);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Counter Wrap-around");
            reset_dut();
            D = 10'h3FF;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            EN = 1;
            @(posedge CLK);
            #1;
            EN = 0;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Intermittent Enable Pulse");
            reset_dut();
            EN = 1;
            @(posedge CLK);
            EN = 0;
            @(posedge CLK);
            EN = 1;
            @(posedge CLK);
            EN = 0;
            @(posedge CLK);
            EN = 1;
            @(posedge CLK);
            #1;
            EN = 0;
            #1;

            check_outputs(10'h003);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Load 0 and increment");
            reset_dut();
            D = 10'h000;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            EN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(10'h001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("loadable_counter Testbench");
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
        input [9:0] expected_Q;
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
        $dumpvars(0,CLK, D, EN, LOAD, RST, Q);
    end

endmodule
