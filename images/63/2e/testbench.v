`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    reg [7:0] D;
    reg WCLK;
    reg WE;
    wire [7:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .D(D),
        .WCLK(WCLK),
        .WE(WE),
        .O(O)
    );

        task reset_dut;

        begin
            A0 = 0; A1 = 0; A2 = 0; A3 = 0; A4 = 0;
            D = 0;
            WCLK = 0;
            WE = 0;
            #20;
        end
        endtask
    task set_addr;

        input [4:0] addr;
        begin
            A0 = addr[0];
            A1 = addr[1];
            A2 = addr[2];
            A3 = addr[3];
            A4 = addr[4];
        end
        endtask

    task write_mem;

        input [4:0] addr;
        input [7:0] data;
        begin
            set_addr(addr);
            D = data;
            WE = 1;
            #5 WCLK = 1;
            #5 WCLK = 0;
            WE = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read Address 0");
            reset_dut();
            write_mem(5'h00, 8'hA5);
            set_addr(5'h00);
            #10;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Write/Read Address 31");
            reset_dut();
            write_mem(5'h1F, 8'h5A);
            set_addr(5'h1F);
            #10;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify Write Enable (WE=0)");
            reset_dut();

            write_mem(5'h0A, 8'h11);

            set_addr(5'h0A);
            D = 8'hEE;
            WE = 0;
            #5 WCLK = 1;
            #5 WCLK = 0;
            #10;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overwrite value at Address 15");
            reset_dut();
            write_mem(5'h0F, 8'hBB);
            write_mem(5'h0F, 8'hCC);
            set_addr(5'h0F);
            #10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Verify Address bit independence");
            reset_dut();
            write_mem(5'b00001, 8'h01);
            write_mem(5'b10000, 8'h10);
            set_addr(5'b00001);
            #10;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Data integrity 0x00 and 0xFF");
            reset_dut();
            write_mem(5'h05, 8'h00);
            write_mem(5'h06, 8'hFF);
            set_addr(5'h06);
            #10;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
        $dumpvars(0,A0, A1, A2, A3, A4, D, WCLK, WE, O);
    end

endmodule
