`timescale 1ns/1ps

module sd_crc_7_tb;

    // Testbench signals (sequential circuit)
    reg BITVAL;
    reg CLK;
    reg Enable;
    reg RST;
    wire [6:0] CRC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_crc_7 dut (
        .BITVAL(BITVAL),
        .CLK(CLK),
        .Enable(Enable),
        .RST(RST),
        .CRC(CRC)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
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
        $display("sd_crc_7 Testbench");
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
        input [6:0] expected_CRC;
        begin
            if (expected_CRC === (expected_CRC ^ CRC ^ expected_CRC)) begin
                $display("PASS");
                $display("  Outputs: CRC=%h",
                         CRC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CRC=%h",
                         expected_CRC);
                $display("  Got:      CRC=%h",
                         CRC);
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
        $dumpvars(0,BITVAL, CLK, Enable, RST, CRC);
    end

endmodule
