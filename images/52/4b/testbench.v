`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D_IN;
    reg RE;
    reg RST_X;
    reg WE;
    wire D_EN;
    wire [7:0] D_OUT;
    wire ERR;
    wire RDY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D_IN(D_IN),
        .RE(RE),
        .RST_X(RST_X),
        .WE(WE),
        .D_EN(D_EN),
        .D_OUT(D_OUT),
        .ERR(ERR),
        .RDY(RDY)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST_X = 0;
            WE = 0;
            RE = 0;
            D_IN = 0;
            #20;
            RST_X = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state check");
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single write and read");
            reset_dut();


            @(posedge CLK);
            WE = 1; D_IN = 8'hAA;
            @(posedge CLK);
            WE = 0;


            #5;


            @(posedge CLK);
            RE = 1;
            @(posedge CLK);
            RE = 0;



            #1;




            check_outputs(1'b1, 8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequence of data (10, 20, 30)");
            reset_dut();


            @(posedge CLK);
            WE = 1; D_IN = 8'd10;
            @(posedge CLK);
            D_IN = 8'd20;
            @(posedge CLK);
            D_IN = 8'd30;
            @(posedge CLK);
            WE = 0;


            @(posedge CLK);
            RE = 1;
            @(posedge CLK);


            @(posedge CLK);


            @(posedge CLK);
            RE = 0;


            #1;



            check_outputs(1'b1, 8'd30, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: RDY signal behavior");
            reset_dut();


            @(posedge CLK);
            WE = 1; D_IN = 8'hFF;
            @(posedge CLK);
            WE = 0;


            #2;


            #1;



            check_outputs(1'b0, 8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Overflow condition (2048 entries)");
            reset_dut();


            WE = 1;
            for (i = 0; i < 2048; i = i + 1) begin
                D_IN = i[7:0];
                @(posedge CLK);
            end


            D_IN = 8'hEE;
            @(posedge CLK);
            WE = 0;

            #2;


            #1;



            check_outputs(1'b0, 8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Interleaved Read and Write");
            reset_dut();


            @(posedge CLK);
            WE = 1; D_IN = 8'h01;
            @(posedge CLK);


            RE = 1; D_IN = 8'h02;
            @(posedge CLK);


            RE = 0; D_IN = 8'h03;
            @(posedge CLK);
            WE = 0;


            @(posedge CLK);
            RE = 1;
            @(posedge CLK);


            @(posedge CLK);
            RE = 0;


            #1;



            check_outputs(1'b1, 8'h03, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Read when empty");
            reset_dut();


            @(posedge CLK);
            RE = 1;
            @(posedge CLK);
            RE = 0;

            #2;

            #1;


            check_outputs(1'b0, 8'h00, 1'b0, 1'b0);
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
        testcase007();
        
        
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
        input expected_D_EN;
        input [7:0] expected_D_OUT;
        input expected_ERR;
        input expected_RDY;
        begin
            if (expected_D_EN === (expected_D_EN ^ D_EN ^ expected_D_EN) &&
                expected_D_OUT === (expected_D_OUT ^ D_OUT ^ expected_D_OUT) &&
                expected_ERR === (expected_ERR ^ ERR ^ expected_ERR) &&
                expected_RDY === (expected_RDY ^ RDY ^ expected_RDY)) begin
                $display("PASS");
                $display("  Outputs: D_EN=%b, D_OUT=%h, ERR=%b, RDY=%b",
                         D_EN, D_OUT, ERR, RDY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_EN=%b, D_OUT=%h, ERR=%b, RDY=%b",
                         expected_D_EN, expected_D_OUT, expected_ERR, expected_RDY);
                $display("  Got:      D_EN=%b, D_OUT=%h, ERR=%b, RDY=%b",
                         D_EN, D_OUT, ERR, RDY);
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
        $dumpvars(0,CLK, D_IN, RE, RST_X, WE, D_EN, D_OUT, ERR, RDY);
    end

endmodule
