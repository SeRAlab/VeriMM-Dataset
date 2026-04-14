`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DIN;
    reg RW;
    wire [3:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .CLK(CLK),
        .DIN(DIN),
        .RW(RW),
        .DOUT(DOUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RW = 1;
            DIN = 4'h0;
            @(posedge CLK);
            RW = 0;
            DIN = 4'h0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write 4'hA and Read");
            reset_dut();
            @(posedge CLK);
            RW = 1; DIN = 4'hA;
            @(posedge CLK);
            RW = 0;
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write 4'h5 and Read");
            reset_dut();
            @(posedge CLK);
            RW = 1; DIN = 4'h5;
            @(posedge CLK);
            RW = 0;
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwrite 4'h3 with 4'hC");
            reset_dut();
            @(posedge CLK);
            RW = 1; DIN = 4'h3;
            @(posedge CLK);
            DIN = 4'hC;
            @(posedge CLK);
            RW = 0;
            #2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Data Retention during Read Mode");
            reset_dut();
            @(posedge CLK);
            RW = 1; DIN = 4'hF;
            @(posedge CLK);
            RW = 0; DIN = 4'h0;
            repeat(2) @(posedge CLK);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Writing all zeros and all ones");
            reset_dut();
            @(posedge CLK);
            RW = 1; DIN = 4'hF;
            @(posedge CLK);
            RW = 1; DIN = 4'h0;
            @(posedge CLK);
            RW = 0;
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [3:0] expected_DOUT;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
        $dumpvars(0,CLK, DIN, RW, DOUT);
    end

endmodule
