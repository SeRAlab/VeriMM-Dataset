`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg [7:0] D;
    reg RE;
    reg WE;
    reg clk;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .A(A),
        .D(D),
        .RE(RE),
        .WE(WE),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 3'b0;
            D = 8'h0;
            RE = 1'b0;
            WE = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            A = 3'd0;
            D = 8'hA5;
            WE = 1'b1;
            RE = 1'b0;
            @(posedge clk);
            #1;


            WE = 1'b0;
            RE = 1'b1;
            @(posedge clk);
            #1;

            $display("Testcase 001: Basic Write/Read Address 0");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            A = 3'd7;
            D = 8'h3C;
            WE = 1'b1;
            RE = 1'b0;
            @(posedge clk);
            #1;


            WE = 1'b0;
            RE = 1'b1;
            @(posedge clk);
            #1;

            $display("Testcase 002: Basic Write/Read Address 7");
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            A = 3'd1; D = 8'h11; WE = 1'b1; RE = 1'b0;
            @(posedge clk); #1;


            A = 3'd2; D = 8'h22; WE = 1'b1; RE = 1'b0;
            @(posedge clk); #1;


            A = 3'd1; WE = 1'b0; RE = 1'b1;
            @(posedge clk); #1;

            $display("Testcase 003: Address Isolation Check");
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            A = 3'd4; D = 8'h55; WE = 1'b1; RE = 1'b0;
            @(posedge clk); #1;


            A = 3'd4; D = 8'hFF; WE = 1'b0; RE = 1'b0;
            @(posedge clk); #1;


            RE = 1'b1;
            @(posedge clk); #1;

            $display("Testcase 004: WE Signal Integrity Check");
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            for(i = 0; i < 8; i = i + 1) begin
                A = i;
                D = i + 8'h10;
                WE = 1'b1;
                @(posedge clk);
                #1;
            end

            WE = 1'b0;
            A = 3'd5;
            RE = 1'b1;
            @(posedge clk);
            #1;

            $display("Testcase 005: Full Array Sequential Access");
            #1;

            check_outputs(8'h15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        $dumpvars(0,A, D, RE, WE, clk, Q);
    end

endmodule
