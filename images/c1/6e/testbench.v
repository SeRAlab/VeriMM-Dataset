`timescale 1ns/1ps

module fm_cmn_ram_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addra;
    reg [1:0] addrb;
    reg clka;
    reg clkb;
    reg [31:0] dia;
    reg wea;
    wire [31:0] doa;
    wire [31:0] dob;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fm_cmn_ram dut (
        .addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dia(dia),
        .wea(wea),
        .doa(doa),
        .dob(dob)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fm_cmn_ram Testbench");
        $display("========================================");


        
        
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
        input [31:0] expected_doa;
        input [31:0] expected_dob;
        begin
            if (expected_doa === (expected_doa ^ doa ^ expected_doa) &&
                expected_dob === (expected_dob ^ dob ^ expected_dob)) begin
                $display("PASS");
                $display("  Outputs: doa=%h, dob=%h",
                         doa, dob);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: doa=%h, dob=%h",
                         expected_doa, expected_dob);
                $display("  Got:      doa=%h, dob=%h",
                         doa, dob);
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
        $dumpvars(0,addra, addrb, clka, clkb, dia, wea, doa, dob);
    end

endmodule
