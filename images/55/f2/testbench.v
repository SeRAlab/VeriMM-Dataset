`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] AA;
    reg [2:0] BA;
    reg CLK;
    reg [2:0] DA;
    reg [15:0] D_data;
    reg RW;
    wire [15:0] A_data;
    wire [15:0] B_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AA(AA),
        .BA(BA),
        .CLK(CLK),
        .DA(DA),
        .D_data(D_data),
        .RW(RW),
        .A_data(A_data),
        .B_data(B_data)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RW = 0;
            DA = 0;
            AA = 0;
            BA = 0;
            D_data = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task write_reg;

        input [2:0] addr;
        input [15:0] data;
        begin
            @(posedge CLK);
            DA = addr;
            D_data = data;
            RW = 1;
            @(posedge CLK);
            #1;
            RW = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Simple Write/Read (Reg 1)");
            reset_dut();
            write_reg(3'd1, 16'hA5A5);


            AA = 3'd1;
            BA = 3'd1;


            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hA5A5, 16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Dual Read Ports (Reg 2 and Reg 5)");
            reset_dut();
            write_reg(3'd2, 16'h1234);
            write_reg(3'd5, 16'hABCD);

            AA = 3'd2;
            BA = 3'd5;

            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h1234, 16'hABCD);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable (RW=0) should inhibit writing");
            reset_dut();

            write_reg(3'd4, 16'h7777);


            @(posedge CLK);
            DA = 3'd4;
            D_data = 16'hEEEE;
            RW = 0;
            @(posedge CLK);
            #1;

            AA = 3'd4;
            BA = 3'd4;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(16'h7777, 16'h7777);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwriting Register 7");
            reset_dut();
            write_reg(3'd7, 16'h1111);
            write_reg(3'd7, 16'hFFFF);

            AA = 3'd7;
            BA = 3'd7;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Boundary Addresses (Reg 0 and Reg 7)");
            reset_dut();
            write_reg(3'd0, 16'h0001);
            write_reg(3'd7, 16'h8000);

            AA = 3'd0;
            BA = 3'd7;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h0001, 16'h8000);
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
        input [15:0] expected_A_data;
        input [15:0] expected_B_data;
        begin
            if (expected_A_data === (expected_A_data ^ A_data ^ expected_A_data) &&
                expected_B_data === (expected_B_data ^ B_data ^ expected_B_data)) begin
                $display("PASS");
                $display("  Outputs: A_data=%h, B_data=%h",
                         A_data, B_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_data=%h, B_data=%h",
                         expected_A_data, expected_B_data);
                $display("  Got:      A_data=%h, B_data=%h",
                         A_data, B_data);
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
        $dumpvars(0,AA, BA, CLK, DA, D_data, RW, A_data, B_data);
    end

endmodule
