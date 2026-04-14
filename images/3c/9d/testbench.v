`timescale 1ns/1ps

module SRAM_8bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CS;
    reg [7:0] D_IN;
    reg WE;
    wire [7:0] D_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_8bit dut (
        .CLK(CLK),
        .CS(CS),
        .D_IN(D_IN),
        .WE(WE),
        .D_OUT(D_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CS = 1;
            WE = 0;
            D_IN = 8'h00;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read (Write 0xAA)");
            reset_dut();


            CS = 0;
            WE = 1;
            D_IN = 8'hAA;
            @(posedge CLK);


            #1;
            WE = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Data Retention with WE=0");
            reset_dut();


            CS = 0;
            WE = 1;
            D_IN = 8'h55;
            @(posedge CLK);


            #1;
            WE = 0;
            D_IN = 8'hFF;
            repeat(3) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write attempt while CS is High (Disabled)");
            reset_dut();


            CS = 0;
            WE = 1;
            D_IN = 8'h12;
            @(posedge CLK);


            #1;
            CS = 1;
            WE = 1;
            D_IN = 8'h34;
            @(posedge CLK);


            #1;
            CS = 0;
            WE = 0;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write attempt while WE is Low");
            reset_dut();


            CS = 0;
            WE = 1;
            D_IN = 8'hCC;
            @(posedge CLK);


            #1;
            WE = 0;
            D_IN = 8'hDD;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Consecutive Write Operations");
            reset_dut();

            CS = 0;
            WE = 1;

            D_IN = 8'h01; @(posedge CLK); #1;
            D_IN = 8'h02; @(posedge CLK); #1;
            D_IN = 8'h03; @(posedge CLK); #1;
            D_IN = 8'h04; @(posedge CLK); #1;

            WE = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h04);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Testing 0x00 and 0xFF");
            reset_dut();


            CS = 0; WE = 1; D_IN = 8'hFF;
            @(posedge CLK);
            #1;
            WE = 0;
            @(posedge CLK);
            #1;
            if (D_OUT !== 8'hFF) begin
                #1;

                check_outputs(8'hFF);
            end else begin

                WE = 1; D_IN = 8'h00;
                @(posedge CLK);
                #1;
                WE = 0;
                @(posedge CLK);
                #1;
                #1;

                check_outputs(8'h00);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_8bit Testbench");
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
        input [7:0] expected_D_OUT;
        begin
            if (expected_D_OUT === (expected_D_OUT ^ D_OUT ^ expected_D_OUT)) begin
                $display("PASS");
                $display("  Outputs: D_OUT=%h",
                         D_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_OUT=%h",
                         expected_D_OUT);
                $display("  Got:      D_OUT=%h",
                         D_OUT);
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
        $dumpvars(0,CLK, CS, D_IN, WE, D_OUT);
    end

endmodule
