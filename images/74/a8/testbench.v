`timescale 1ns/1ps

module dff_async_reset_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg RST;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dff_async_reset dut (
        .CLK(CLK),
        .D(D),
        .RST(RST),
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
        D = 8'h00;
        #12;
        RST = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic data capture (0xA5)", test_num);
        reset_dut();
        D = 8'hA5;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic data capture (0x5A)", test_num);
        reset_dut();
        D = 8'h5A;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Capture all bits high (0xFF)", test_num);
        reset_dut();
        D = 8'hFF;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Asynchronous reset behavior", test_num);
        reset_dut();
        D = 8'hCC;
        @(posedge CLK);
        #2;
        RST = 1;
        #1;
        #1;

        check_outputs(8'h00);
        RST = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Data stability on falling edge", test_num);
        reset_dut();
        D = 8'h11;
        @(posedge CLK);
        #2;
        D = 8'h22;
        @(negedge CLK);
        #2;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Multiple clock transitions", test_num);
        reset_dut();
        D = 8'h10;
        @(posedge CLK);
        #2;
        D = 8'h20;
        @(posedge CLK);
        #2;
        D = 8'h30;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(8'h30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dff_async_reset Testbench");
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
        $dumpvars(0,CLK, D, RST, Q);
    end

endmodule
