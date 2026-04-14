`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] Data_in;
    reg REN;
    reg RESET;
    reg WEN;
    reg valid;
    wire [7:0] Data_out;
    wire [7:0] Empty_out;
    wire [7:0] Full_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .Data_in(Data_in),
        .REN(REN),
        .RESET(RESET),
        .WEN(WEN),
        .valid(valid),
        .Data_out(Data_out),
        .Empty_out(Empty_out),
        .Full_out(Full_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            WEN = 0;
            REN = 0;
            valid = 0;
            Data_in = 0;
            repeat (2) @(posedge CLK);
            #1 RESET = 0;
            repeat (1) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read...");
            reset_dut();


            @(posedge CLK);
            WEN = 1; valid = 1; Data_in = 8'hA5;
            @(posedge CLK);
            WEN = 0; valid = 0;


            @(posedge CLK);
            REN = 1;
            @(posedge CLK);
            REN = 0;

            #1 #1;
 check_outputs(8'hA5, 8'hFF, 8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Running testcase002: Fill to Full...");
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge CLK);
                WEN = 1; valid = 1; Data_in = i + 1;
            end
            @(posedge CLK);
            WEN = 0; valid = 0;

            #1 #1;
 check_outputs(8'hzz, 8'h00, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Empty Status Check...");
            reset_dut();


            @(posedge CLK);
            WEN = 1; valid = 1; Data_in = 8'hCC;
            @(posedge CLK);
            WEN = 0; valid = 0;


            @(posedge CLK);
            REN = 1;
            @(posedge CLK);
            REN = 0;

            #1 #1;
 check_outputs(8'hCC, 8'hFF, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Simultaneous Write and Read...");
            reset_dut();


            @(posedge CLK);
            WEN = 1; valid = 1; Data_in = 8'h11;
            @(posedge CLK);


            WEN = 1; valid = 1; Data_in = 8'h22; REN = 1;
            @(posedge CLK);
            WEN = 0; REN = 0;

            #1 #1;
 check_outputs(8'h11, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset mid-operation...");
            reset_dut();


            @(posedge CLK);
            WEN = 1; valid = 1; Data_in = 8'h55;
            @(posedge CLK);
            WEN = 1; valid = 1; Data_in = 8'h66;
            @(posedge CLK);


            RESET = 1;
            @(posedge CLK);
            RESET = 0;

            #1 #1;
 check_outputs(8'h00, 8'hFF, 8'h00);
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
        input [7:0] expected_Data_out;
        input [7:0] expected_Empty_out;
        input [7:0] expected_Full_out;
        begin
            if (expected_Data_out === (expected_Data_out ^ Data_out ^ expected_Data_out) &&
                expected_Empty_out === (expected_Empty_out ^ Empty_out ^ expected_Empty_out) &&
                expected_Full_out === (expected_Full_out ^ Full_out ^ expected_Full_out)) begin
                $display("PASS");
                $display("  Outputs: Data_out=%h, Empty_out=%h, Full_out=%h",
                         Data_out, Empty_out, Full_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_out=%h, Empty_out=%h, Full_out=%h",
                         expected_Data_out, expected_Empty_out, expected_Full_out);
                $display("  Got:      Data_out=%h, Empty_out=%h, Full_out=%h",
                         Data_out, Empty_out, Full_out);
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
        $dumpvars(0,CLK, Data_in, REN, RESET, WEN, valid, Data_out, Empty_out, Full_out);
    end

endmodule
