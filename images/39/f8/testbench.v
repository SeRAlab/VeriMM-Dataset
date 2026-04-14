`timescale 1ns/1ps

module eeprom_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg RE;
    reg WE;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom dut (
        .CLK(CLK),
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            D = 8'h0;
            RE = 0;
            WE = 0;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic Write and Read (0xAA)");
            reset_dut();


            @(negedge CLK);
            D = 8'hAA;
            WE = 1;
            RE = 0;
            @(negedge CLK);
            WE = 0;


            RE = 1;
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Overwrite existing value (0x55 -> 0xFF)");
            reset_dut();


            @(negedge CLK);
            D = 8'h55;
            WE = 1;
            @(negedge CLK);


            D = 8'hFF;
            WE = 1;
            @(negedge CLK);
            WE = 0;


            RE = 1;
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Verify WE (Should not write when WE is low)");
            reset_dut();


            @(negedge CLK);
            D = 8'h12;
            WE = 1;
            @(negedge CLK);


            D = 8'h34;
            WE = 0;
            @(negedge CLK);


            RE = 1;
            #1;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Data retention with RE and WE low");
            reset_dut();


            @(negedge CLK);
            D = 8'hBE;
            WE = 1;
            @(negedge CLK);


            WE = 0;
            RE = 0;
            D = 8'h00;
            repeat(3) @(negedge CLK);


            RE = 1;
            #1;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Simultaneous Read and Write");
            reset_dut();


            @(negedge CLK);
            D = 8'h11;
            WE = 1;
            @(negedge CLK);


            D = 8'h22;
            WE = 1;
            RE = 1;
            @(negedge CLK);


            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom Testbench");
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
        input [7:0] expected_Q;
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
        $dumpvars(0,CLK, D, RE, WE, Q);
    end

endmodule
