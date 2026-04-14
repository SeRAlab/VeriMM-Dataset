`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] A;
    reg CE;
    reg CSB;
    reg [127:0] I;
    reg OEB;
    reg WEB;
    wire [127:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .CE(CE),
        .CSB(CSB),
        .I(I),
        .OEB(OEB),
        .WEB(WEB),
        .O(O)
    );

    // Clock generation (10ns period)
    initial begin
        CE = 0;
        forever #5 CE = ~CE;
    end

        task reset_dut;

        begin
            @(negedge CE);
            CSB = 1;
            WEB = 1;
            OEB = 1;
            A = 0;
            I = 0;
            repeat (2) @(posedge CE);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read at Addr 0");
            reset_dut();
            write_word(7'd0, 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
            read_word_setup(7'd0);
            #1;

            check_outputs(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write and Read at Addr 63");
            reset_dut();
            write_word(7'd63, 128'h55555555555555555555555555555555);
            read_word_setup(7'd63);
            #1;

            check_outputs(128'h55555555555555555555555555555555);
        end
        endtask

    task testcase003;

        reg [127:0] original_data;
        begin
            $display("Testcase 003: Verify CSB prevents writing");
            reset_dut();
            original_data = 128'h11112222333344445555666677778888;
            write_word(7'd10, original_data);


            @(negedge CE);
            CSB = 1; WEB = 0; A = 7'd10; I = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            @(posedge CE);
            #1;

            read_word_setup(7'd10);
            #1;

            check_outputs(original_data);
        end
        endtask

    task testcase004;

        reg [127:0] original_data;
        begin
            $display("Testcase 004: Verify WEB prevents writing");
            reset_dut();
            original_data = 128'hDEADBEEFDEADBEEFDEADBEEFDEADBEEF;
            write_word(7'd20, original_data);


            @(negedge CE);
            CSB = 0; WEB = 1; A = 7'd20; I = 128'h00000000000000000000000000000000;
            @(posedge CE);
            #1;

            read_word_setup(7'd20);
            #1;

            check_outputs(original_data);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple Address Data Integrity");
            reset_dut();
            write_word(7'd5,  128'h1);
            write_word(7'd15, 128'h2);
            write_word(7'd25, 128'h3);

            read_word_setup(7'd5);


            if (O !== 128'h1) fail_count++;

            read_word_setup(7'd15);
            if (O !== 128'h2) fail_count++;

            read_word_setup(7'd25);
            #1;

            check_outputs(128'h3);
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
        input [127:0] expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
        $dumpvars(0,A, CE, CSB, I, OEB, WEB, O);
    end

endmodule
