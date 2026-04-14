`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA;
    reg DATARDY;
    reg EN;
    reg RST;
    wire READ;
    wire TX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA(DATA),
        .DATARDY(DATARDY),
        .EN(EN),
        .RST(RST),
        .READ(READ),
        .TX(TX)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            EN = 0;
            DATA = 0;
            DATARDY = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            EN = 1;
            DATA = 8'h55;
            DATARDY = 1;
            @(posedge CLK);
            #1;
            DATARDY = 0;




            wait(READ === 1);
            wait(READ === 0);
            @(posedge CLK);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            EN = 0;
            DATA = 8'hAA;
            DATARDY = 1;
            repeat(5) @(posedge CLK);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            EN = 1;
            DATA = 8'hFF;
            DATARDY = 1;
            @(posedge CLK);
            wait(READ === 1);
            repeat(4) @(posedge CLK);

            RST = 1;
            @(posedge CLK);
            RST = 0;
            @(posedge CLK);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;


            EN = 1; DATA = 8'h00; DATARDY = 1;
            @(posedge CLK);
            #1; DATARDY = 0;
            wait(READ === 0);
            @(posedge CLK);


            DATA = 8'hFF; DATARDY = 1;
            @(posedge CLK);
            #1; DATARDY = 0;
            wait(READ === 0);
            @(posedge CLK);

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_READ;
        input expected_TX;
        begin
            if (expected_READ === (expected_READ ^ READ ^ expected_READ) &&
                expected_TX === (expected_TX ^ TX ^ expected_TX)) begin
                $display("PASS");
                $display("  Outputs: READ=%b, TX=%b",
                         READ, TX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: READ=%b, TX=%b",
                         expected_READ, expected_TX);
                $display("  Got:      READ=%b, TX=%b",
                         READ, TX);
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
        $dumpvars(0,CLK, DATA, DATARDY, EN, RST, READ, TX);
    end

endmodule
