`timescale 1ns/1ps

module regamma_tb;

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
    regamma dut (
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
            initialize = 0;
            load = 0;
            datain = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initialization Signal");
            reset_dut();
            initialize = 1;
            load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Loading Data 5'h0A");
            reset_dut();
            initialize = 0;
            load = 1;
            datain = 5'h0A;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Default State (Load=0, Init=0)");
            reset_dut();

            load = 1;
            datain = 5'h1F;
            @(posedge clock);
            #1;

            load = 0;
            initialize = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Priority Check (Init vs Load)");
            reset_dut();
            initialize = 1;
            load = 1;
            datain = 5'h05;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Loading All Ones");
            reset_dut();
            initialize = 0;
            load = 1;
            datain = 5'b11111;
            @(posedge clock);
            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("regamma Testbench");
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
