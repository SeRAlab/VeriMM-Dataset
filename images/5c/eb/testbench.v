`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    reg D;
    reg WCLK;
    reg WE;
    wire O;

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
    task set_address;

        input [4:0] addr;
        begin
            A0 = addr[0];
            A1 = addr[1];
            A2 = addr[2];
            A3 = addr[3];
            A4 = addr[4];
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Write '1' to Address 0", test_num);
        set_address(5'd0);
        D = 1;
        WE = 1;
        #10 WCLK = 1;
        #10 WCLK = 0;
        WE = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Write '1' to Address 31", test_num);
        set_address(5'd31);
        D = 1;
        WE = 1;
        #10 WCLK = 1;
        #10 WCLK = 0;
        WE = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Write Enable (WE=0 prevents update)", test_num);

        set_address(5'd10);
        D = 1;
        WE = 1;
        #10 WCLK = 1; #10 WCLK = 0;

        D = 0;
        WE = 0;
        #10 WCLK = 1; #10 WCLK = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Overwrite value at address 15", test_num);
        set_address(5'd15);
        D = 1;
        WE = 1;
        #10 WCLK = 1; #10 WCLK = 0;
        D = 0;
        WE = 1;
        #10 WCLK = 1; #10 WCLK = 0;
        WE = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Address decoding (Write to 5, read from 6)", test_num);
        set_address(5'd5);
        D = 1;
        WE = 1;
        #10 WCLK = 1; #10 WCLK = 0;
        WE = 0;
        set_address(5'd6);
        #10;

        #1;


        check_outputs(1'b0);
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
        input expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
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
