`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
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
        .D(D),
        .WCLK(WCLK),
        .WE(WE),
        .O(O)
    );

        task reset_dut;

        begin
            A3 = 0; A2 = 0; A1 = 0; A0 = 0;
            D = 8'h00;
            WCLK = 0;
            WE = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write/Read at Address 0", test_num);
            write_mem(4'h0, 8'hA5);
            set_addr(4'h0);
            #10;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Basic Write/Read at Address 15", test_num);
            write_mem(4'hF, 8'h5A);
            set_addr(4'hF);
            #10;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Verify WE=0 prevents writing", test_num);

            write_mem(4'h7, 8'h77);

            set_addr(4'h7);
            D = 8'h88;
            WE = 0;
            #10;
            WCLK = 1; #10; WCLK = 0;
            #10;

            #1;


            check_outputs(8'h77);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Persistence and Multiple Address check", test_num);
            write_mem(4'h1, 8'h11);
            write_mem(4'h2, 8'h22);

            set_addr(4'h1);
            #10;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Overwriting data at the same address", test_num);
            write_mem(4'hA, 8'hAA);
            write_mem(4'hA, 8'hBB);
            set_addr(4'hA);
            #10;
            #1;

            check_outputs(8'hBB);
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
        $dumpvars(0,A0, A1, A2, A3, D, WCLK, WE, O);
    end

endmodule
