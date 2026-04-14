`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addra;
    reg clka;
    reg [11:0] dina;
    reg wea;
    wire [11:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .clka(clka),
        .dina(dina),
        .wea(wea),
        .douta(douta)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

        begin
            wea <= 0;
            addra <= 0;
            dina <= 0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Write/Read");
            reset_dut();

            wea <= 1; addra <= 12'h010; dina <= 12'hABC;
            @(posedge clka);
            #1;

            wea <= 0; addra <= 12'h010;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Minimum Address (0x000)");
            reset_dut();

            wea <= 1; addra <= 12'h000; dina <= 12'h123;
            @(posedge clka);
            #1;
            wea <= 0; addra <= 12'h000;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Maximum Address (0xFFF)");
            reset_dut();

            wea <= 1; addra <= 12'hFFF; dina <= 12'hFED;
            @(posedge clka);
            #1;
            wea <= 0; addra <= 12'hFFF;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'hFED);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Overwrite existing address");
            reset_dut();

            wea <= 1; addra <= 12'h0A5; dina <= 12'h555;
            @(posedge clka);
            #1;

            wea <= 1; addra <= 12'h0A5; dina <= 12'hAAA;
            @(posedge clka);
            #1;

            wea <= 0; addra <= 12'h0A5;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Write Enable (wea) False check");
            reset_dut();

            wea <= 1; addra <= 12'h020; dina <= 12'h777;
            @(posedge clka);
            #1;

            wea <= 0; addra <= 12'h020; dina <= 12'h000;
            @(posedge clka);
            #1;

            wea <= 0; addra <= 12'h020;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'h777);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Data integrity across unique addresses");
            reset_dut();

            wea <= 1; addra <= 12'h100; dina <= 12'h111;
            @(posedge clka);
            #1;

            wea <= 1; addra <= 12'h200; dina <= 12'h222;
            @(posedge clka);
            #1;

            wea <= 0; addra <= 12'h100;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'h111);
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
        input [11:0] expected_douta;
        begin
            if (expected_douta === (expected_douta ^ douta ^ expected_douta)) begin
                $display("PASS");
                $display("  Outputs: douta=%h",
                         douta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: douta=%h",
                         expected_douta);
                $display("  Got:      douta=%h",
                         douta);
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
        $dumpvars(0,addra, clka, dina, wea, douta);
    end

endmodule
