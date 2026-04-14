`timescale 1ns/1ps

module ripple_addsub_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CLK;
    reg SUB;
    wire CARRY_OUT;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_addsub dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .SUB(SUB),
        .CARRY_OUT(CARRY_OUT),
        .SUM(SUM)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        A = 8'd0;
        B = 8'd0;
        SUB = 1'b0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: 15 + 10 (Addition, No Carry)");
        reset_dut();
        A = 8'd15;
        B = 8'd10;
        SUB = 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0, 8'd25);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: 250 + 10 (Addition, With Carry)");
        reset_dut();
        A = 8'd250;
        B = 8'd10;
        SUB = 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1, 8'd4);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: 0 + 0");
        reset_dut();
        A = 8'h00;
        B = 8'h00;
        SUB = 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: 50 - 20 (Subtraction, No Borrow)");
        reset_dut();
        A = 8'd50;
        B = 8'd20;
        SUB = 1'b1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: 20 - 50 (Subtraction, With Borrow)");
        reset_dut();
        A = 8'd20;
        B = 8'd50;
        SUB = 1'b1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1, 8'hE2);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: 128 - 128");
        reset_dut();
        A = 8'd128;
        B = 8'd128;
        SUB = 1'b1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: 255 + 255");
        reset_dut();
        A = 8'hFF;
        B = 8'hFF;
        SUB = 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1, 8'hFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ripple_addsub Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_CARRY_OUT;
        input [7:0] expected_SUM;
        begin
            if (expected_CARRY_OUT === (expected_CARRY_OUT ^ CARRY_OUT ^ expected_CARRY_OUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY_OUT=%b, SUM=%h",
                         expected_CARRY_OUT, expected_SUM);
                $display("  Got:      CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
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
        $dumpvars(0,A, B, CLK, SUB, CARRY_OUT, SUM);
    end

endmodule
