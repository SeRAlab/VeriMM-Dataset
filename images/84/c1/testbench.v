`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addra;
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
        wea = 0;
        addra = 0;
        dina = 0;

        repeat (2) @(posedge clka);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Write and Read...");
        reset_dut();


        @(posedge clka);
        wea = 1;
        addra = 14'h0000;
        dina = 12'h0AA;


        @(posedge clka);
        wea = 0;
        addra = 14'h0000;


        #1;
        #1;

        check_outputs(12'h0AA);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: 8-bit Truncation Check...");
        reset_dut();

        @(posedge clka);
        wea = 1;
        addra = 14'h0123;
        dina = 12'hFFF;

        @(posedge clka);
        wea = 0;
        addra = 14'h0123;

        #1;
        #1;

        check_outputs(12'h0FF);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Tri-state Logic Check...");
        reset_dut();

        @(posedge clka);
        wea = 1;
        addra = 14'h0555;
        dina = 12'h012;


        #1;
        #1;

        check_outputs(12'bzzzz_zzzz_zzzz);

        @(posedge clka);
        wea = 0;
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Boundary Address Check...");
        reset_dut();

        @(posedge clka);
        wea = 1;
        addra = 14'h3FFF;
        dina = 12'h0C3;

        @(posedge clka);
        wea = 0;
        addra = 14'h3FFF;

        #1;
        #1;

        check_outputs(12'h0C3);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Overwrite Check...");
        reset_dut();


        @(posedge clka);
        wea = 1;
        addra = 14'h0A22;
        dina = 12'h011;


        @(posedge clka);
        wea = 1;
        addra = 14'h0A22;
        dina = 12'h0EE;

        @(posedge clka);
        wea = 0;
        addra = 14'h0A22;

        #1;
        #1;

        check_outputs(12'h0EE);
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
