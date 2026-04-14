`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] D;
    reg RE;
    reg RST;
    reg WE;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .D(D),
        .RE(RE),
        .RST(RST),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RE = 0;
        forever #5 RE = ~RE;
    end

        task reset_dut;

    begin
        RST = 1;
        D = 16'h0;
        WE = 0;
        #20;
        RST = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset check", test_num);
        reset_dut();

        wait(RE == 1);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Write/Read (0xABCD)", test_num);
        reset_dut();
        D = 16'hABCD;
        WE = 1;
        #20;
        WE = 0;
        #10;
        wait(RE == 1);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Data Persistence check", test_num);
        reset_dut();

        D = 16'h55AA;
        WE = 1;
        #20;
        WE = 0;

        D = 16'hFFFF;
        #20;
        wait(RE == 1);
        #1;
        #1;

        check_outputs(16'h55AA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Successive Writes (Overwrite)", test_num);
        reset_dut();

        D = 16'h1111;
        WE = 1;
        #20;

        D = 16'h2222;
        #20;
        WE = 0;
        wait(RE == 1);
        #1;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority over WE", test_num);
        reset_dut();
        D = 16'hFFFF;
        WE = 1;
        RST = 1;
        #20;
        RST = 0;
        WE = 0;
        wait(RE == 1);
        #1;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All Bits Toggle (0xFFFF)", test_num);
        reset_dut();
        D = 16'hFFFF;
        WE = 1;
        #20;
        WE = 0;
        wait(RE == 1);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_Q;
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
        $dumpvars(0,D, RE, RST, WE, Q);
    end

endmodule
