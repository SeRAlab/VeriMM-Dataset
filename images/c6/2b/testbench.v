`timescale 1ns/1ps

module adder_subtractor_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg C;
    reg CLK;
    wire [15:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_subtractor dut (
        .A(A),
        .B(B),
        .C(C),
        .CLK(CLK),
        .R(R)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        A = 0;
        B = 0;
        C = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case 001: 10 + 20 (C=0)");
        A = 16'd10;
        B = 16'd20;
        C = 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(16'd30);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case 002: 50 - 20 (C=1)");
        A = 16'd50;
        B = 16'd20;
        C = 1'b1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(16'd30);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case 003: 0xFFFF + 1 (C=0)");
        A = 16'hFFFF;
        B = 16'h0001;
        C = 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case 004: 0 - 1 (C=1)");
        A = 16'h0000;
        B = 16'h0001;
        C = 1'b1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case 005: 0xAAAA + 0x5555 (C=0)");
        A = 16'hAAAA;
        B = 16'h5555;
        C = 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test Case 006: 0x1234 - 0x1234 (C=1)");
        A = 16'h1234;
        B = 16'h1234;
        C = 1'b1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test Case 007: 0x4000 - 0x8000 (C=1)");
        A = 16'h4000;
        B = 16'h8000;
        C = 1'b1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(16'hC000);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Test Case 008: 0x1234 + 0 (C=0)");
        A = 16'h1234;
        B = 16'h0000;
        C = 1'b0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_subtractor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_R;
        begin
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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
        $dumpvars(0,A, B, C, CLK, R);
    end

endmodule
