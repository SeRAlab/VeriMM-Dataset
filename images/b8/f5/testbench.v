`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg D0;
    reg D1;
    reg WCLK;
    reg WE;
    wire O0;
    wire O1;

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
        .D0(D0),
        .D1(D1),
        .WCLK(WCLK),
        .WE(WE),
        .O0(O0),
        .O1(O1)
    );

        task reset_dut;

        begin
            A0 = 0; A1 = 0; A2 = 0; A3 = 0;
            D0 = 0; D1 = 0;
            WCLK = 0;
            WE = 0;
            #20;
        end
        endtask
    task write_ram;

        input [3:0] addr;
        input [1:0] data;
        begin
            {A3, A2, A1, A0} = addr;
            {D1, D0} = data;
            WE = 1;
            #10 WCLK = 1;
            #10 WCLK = 0;
            WE = 0;
            #10;
        end
        endtask

    task set_addr;

        input [3:0] addr;
        begin
            {A3, A2, A1, A0} = addr;
            #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write/Read Address 0", test_num);
            reset_dut();
            write_ram(4'b0000, 2'b11);
            set_addr(4'b0000);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write/Read Address 15", test_num);
            reset_dut();
            write_ram(4'b1111, 2'b01);
            set_addr(4'b1111);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Verify WE=0 prevents writing", test_num);
            reset_dut();

            write_ram(4'b0101, 2'b11);

            {A3, A2, A1, A0} = 4'b0101;
            {D1, D0} = 2'b00;
            WE = 0;
            #10 WCLK = 1; #10 WCLK = 0;
            #10;
            set_addr(4'b0101);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overwriting memory location", test_num);
            reset_dut();
            write_ram(4'b1010, 2'b11);
            write_ram(4'b1010, 2'b00);
            set_addr(4'b1010);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multiple address persistence", test_num);
            reset_dut();
            write_ram(4'b0001, 2'b01);
            write_ram(4'b0010, 2'b10);
            set_addr(4'b0001);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Bit independence check", test_num);
            reset_dut();
            write_ram(4'b1000, 2'b10);
            set_addr(4'b1000);
            #1;

            check_outputs(0, 1);
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
        input expected_O0;
        input expected_O1;
        begin
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b",
                         O0, O1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b",
                         expected_O0, expected_O1);
                $display("  Got:      O0=%b, O1=%b",
                         O0, O1);
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
        $dumpvars(0,A0, A1, A2, A3, D0, D1, WCLK, WE, O0, O1);
    end

endmodule
