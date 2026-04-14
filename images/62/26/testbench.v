`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] A;
    reg [8:0] B;
    reg CLK1;
    reg CLK2;
    wire [17:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK1(CLK1),
        .CLK2(CLK2),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        CLK1 = 0;
        forever #5 CLK1 = ~CLK1;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            CLK2 = 0;
            @(posedge CLK1);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 9'd15;
            B = 9'd10;
            @(posedge CLK1);
            #2;
            $display("Testcase 001: Full Update (15 * 10 = 150)");
            #1;

            check_outputs(18'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 9'd7;
            B = 9'd8;
            #1 CLK2 = 1; #5 CLK2 = 0;
            #2;
            $display("Testcase 002: Partial Update (7 * 8 = 56)");
            #1;

            check_outputs(18'd56);
        end
        endtask

    task testcase003;

        reg [17:0] product;
        begin
            test_num = 3;
            reset_dut();

            A = 9'd511;
            B = 9'd2;
            @(posedge CLK1);
            #2;





            A = 9'd1;
            B = 9'd1;
            #1 CLK2 = 1; #5 CLK2 = 0;
            #2;
            $display("Testcase 003: Upper Bit Persistence (CLK1 sets 1022, CLK2 sets LSB to 1)");
            #1;

            check_outputs(18'd513);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 9'h1FF;
            B = 9'h1FF;
            @(posedge CLK1);
            #2;
            $display("Testcase 004: Maximum Values (511 * 511 = 261121)");
            #1;

            check_outputs(18'd261121);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            A = 9'd511;
            B = 9'd511;
            @(posedge CLK1);
            #2;




            A = 9'd0;
            B = 9'd0;
            #1 CLK2 = 1; #5 CLK2 = 0;
            #2;
            $display("Testcase 005: Selective Clear via CLK2");
            #1;

            check_outputs(18'd261632);
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
        input [17:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,A, B, CLK1, CLK2, Z);
    end

endmodule
