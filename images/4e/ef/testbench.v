`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg SI;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .CLK(CLK),
        .RST(RST),
        .SI(SI),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        SI = 0;
        @(posedge CLK);
        #1 RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Reset Verification");
        reset_dut();

        @(negedge CLK);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Shift 0xAA (Alternating Bits)");
        reset_dut();

        @(negedge CLK) SI = 1;
        @(negedge CLK) SI = 0;
        @(negedge CLK) SI = 1;
        @(negedge CLK) SI = 0;
        @(negedge CLK) SI = 1;
        @(negedge CLK) SI = 0;
        @(negedge CLK) SI = 1;
        @(negedge CLK) SI = 0;
        @(posedge CLK);
        #1 #1;
 check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Shift All Ones (0xFF)");
        reset_dut();
        repeat(8) begin
            @(negedge CLK) SI = 1;
        end
        @(posedge CLK);
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Overflow / 12-bit Shift");
        reset_dut();

        repeat(4) @(negedge CLK) SI = 0;
        repeat(4) @(negedge CLK) SI = 1;

        @(negedge CLK) SI = 1;
        @(negedge CLK) SI = 0;
        @(negedge CLK) SI = 1;
        @(negedge CLK) SI = 0;
        @(negedge CLK) SI = 0;
        @(negedge CLK) SI = 1;
        @(negedge CLK) SI = 0;
        @(negedge CLK) SI = 1;
        @(posedge CLK);
        #1 #1;
 check_outputs(8'hA5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Mid-operation Reset");
        reset_dut();
        repeat(4) @(negedge CLK) SI = 1;
        @(negedge CLK) RST = 1;
        @(posedge CLK);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Single Bit Shift");
        reset_dut();
        @(negedge CLK) SI = 1;
        @(posedge CLK);
        #1 #1;
 check_outputs(8'h01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        $dumpvars(0,CLK, RST, SI, Q);
    end

endmodule
