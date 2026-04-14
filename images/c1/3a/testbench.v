`timescale 1ns/1ps

module regkr_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [4:0] datain;
    reg initialize;
    reg load;
    wire [4:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    regkr dut (
        .clock(clock),
        .datain(datain),
        .initialize(initialize),
        .load(load),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        initialize = 1;
        load = 0;
        datain = 0;
        @(posedge clock);
        #1;
        initialize = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Load Operation");
        reset_dut();
        datain = 5'h1A;
        load = 1;
        initialize = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(5'h1A);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Hold Value (Load=0)");
        reset_dut();

        datain = 5'h0F;
        load = 1;
        @(posedge clock);
        #1;

        datain = 5'h15;
        load = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(5'h0F);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Initialize Priority over Load");
        reset_dut();
        datain = 5'h1F;
        load = 1;
        initialize = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Data Integrity (Max value)");
        reset_dut();
        datain = 5'h1F;
        load = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Initialize from loaded state");
        reset_dut();

        datain = 5'h0A;
        load = 1;
        @(posedge clock);
        #1;

        load = 0;
        initialize = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(5'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("regkr Testbench");
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
        input [4:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,clock, datain, initialize, load, dataout);
    end

endmodule
