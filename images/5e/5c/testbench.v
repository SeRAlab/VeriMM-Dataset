`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ACK;
    reg CLK;
    reg [7:0] IN;
    reg RESET;
    reg WR;
    wire [7:0] OUT;
    wire RDA;
    wire RDY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACK(ACK),
        .CLK(CLK),
        .IN(IN),
        .RESET(RESET),
        .WR(WR),
        .OUT(OUT),
        .RDA(RDA),
        .RDY(RDY)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            WR = 0;
            ACK = 0;
            IN = 8'h00;
            @(posedge CLK);
            #1 RESET = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple Write Operation");
            reset_dut();

            @(posedge CLK);
            IN = 8'hA5;
            WR = 1;
            @(posedge CLK);
            #1 WR = 0;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write followed by Acknowledge");
            reset_dut();


            @(posedge CLK);
            IN = 8'h5A;
            WR = 1;
            @(posedge CLK);
            #1 WR = 0;


            @(posedge CLK);
            ACK = 1;
            @(posedge CLK);
            #1 ACK = 0;



            #1;




            check_outputs(8'h5A, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Consecutive Cycles");
            reset_dut();


            @(posedge CLK);
            IN = 8'h11;
            WR = 1;
            @(posedge CLK);
            #1 WR = 0; ACK = 1;
            @(posedge CLK);
            #1 ACK = 0;


            @(posedge CLK);
            IN = 8'h22;
            WR = 1;
            @(posedge CLK);
            #1 WR = 0;


            #1;



            check_outputs(8'h22, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Full Handshake Sequence");
            reset_dut();

            @(posedge CLK);
            IN = 8'hFF;
            WR = 1;
            @(posedge CLK);
            #1 WR = 0;


            @(posedge CLK);


            ACK = 1;
            @(posedge CLK);
            #1 ACK = 0;


            #1;



            check_outputs(8'hFF, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Data ignored when WR is low");
            reset_dut();

            @(posedge CLK);
            IN = 8'hCC;
            WR = 0;
            @(posedge CLK);
            IN = 8'hDD;
            @(posedge CLK);


            #1;



            check_outputs(8'h00, 1'b0, 1'b1);
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
        input [7:0] expected_OUT;
        input expected_RDA;
        input expected_RDY;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT) &&
                expected_RDA === (expected_RDA ^ RDA ^ expected_RDA) &&
                expected_RDY === (expected_RDY ^ RDY ^ expected_RDY)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h, RDA=%b, RDY=%b",
                         OUT, RDA, RDY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h, RDA=%b, RDY=%b",
                         expected_OUT, expected_RDA, expected_RDY);
                $display("  Got:      OUT=%h, RDA=%b, RDY=%b",
                         OUT, RDA, RDY);
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
        $dumpvars(0,ACK, CLK, IN, RESET, WR, OUT, RDA, RDY);
    end

endmodule
