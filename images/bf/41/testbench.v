`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] Address;
    reg Clk;
    reg [3:0] Data_in;
    reg RW;
    wire [3:0] Data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .Clk(Clk),
        .Data_in(Data_in),
        .RW(RW),
        .Data_out(Data_out)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Address = 0;
            Data_in = 0;
            RW = 0;

            @(posedge Clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Basic Write and Read (Addr 0)");


            RW = 1;
            Address = 3'd0;
            Data_in = 4'hA;
            @(negedge Clk);
            #2;


            RW = 0;
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: High-Impedance check during Write");

            RW = 1;
            Address = 3'd1;
            Data_in = 4'h5;
            #2;
            #1;

            check_outputs(4'bz);

            @(negedge Clk);
            #2;
            #1;

            check_outputs(4'bz);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            $display("Testcase 003: Multiple register isolation test");


            for (i = 0; i < 8; i = i + 1) begin
                RW = 1;
                Address = i;
                Data_in = i;
                @(negedge Clk);
                #2;
            end


            RW = 0;
            for (i = 0; i < 8; i = i + 1) begin
                Address = i;
                #2;
                $display("Checking Addr %0d", i);
                #1;

                check_outputs(i[3:0]);
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Overwrite value test");


            RW = 1;
            Address = 3'd5;
            Data_in = 4'hC;
            @(negedge Clk);
            #2;


            Data_in = 4'h3;
            @(negedge Clk);
            #2;

            RW = 0;
            #2;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Falling edge sensitivity check");


            RW = 1;
            Address = 3'd2;
            Data_in = 4'hF;
            @(negedge Clk);
            #2;


            Data_in = 4'h1;
            @(posedge Clk);
            #2;


            RW = 0;
            #2;


            Address = 3'd2;
            #2;
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_Data_out;
        begin
            if (expected_Data_out === (expected_Data_out ^ Data_out ^ expected_Data_out)) begin
                $display("PASS");
                $display("  Outputs: Data_out=%h",
                         Data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_out=%h",
                         expected_Data_out);
                $display("  Got:      Data_out=%h",
                         Data_out);
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
        $dumpvars(0,Address, Clk, Data_in, RW, Data_out);
    end

endmodule
