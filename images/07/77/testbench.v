`timescale 1ns/1ps

module qam_demodulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] received_signal;
    reg rst;
    wire [1:0] I;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_demodulator dut (
        .clk(clk),
        .received_signal(received_signal),
        .rst(rst),
        .I(I),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        received_signal = 4'b0000;
        @(posedge clk);
        #2;
        rst = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        received_signal = 4'b0000;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Input 4'b0000", test_num);
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        received_signal = 4'b1111;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Input 4'b1111", test_num);
        #1;

        check_outputs(2'b11, 2'b11);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        received_signal = 4'b1010;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Input 4'b1010", test_num);
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        received_signal = 4'b0101;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Input 4'b0101", test_num);
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        received_signal = 4'b1100;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Input 4'b1100", test_num);
        #1;

        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        received_signal = 4'b0011;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Input 4'b0011", test_num);
        #1;

        check_outputs(2'b00, 2'b11);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        received_signal = 4'b1001;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Input 4'b1001", test_num);
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        received_signal = 4'b0110;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Input 4'b0110", test_num);
        #1;

        check_outputs(2'b01, 2'b10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_demodulator Testbench");
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
        input [1:0] expected_I;
        input [1:0] expected_Q;
        begin
            if (expected_I === (expected_I ^ I ^ expected_I) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: I=%h, Q=%h",
                         I, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I=%h, Q=%h",
                         expected_I, expected_Q);
                $display("  Got:      I=%h, Q=%h",
                         I, Q);
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
        $dumpvars(0,clk, received_signal, rst, I, Q);
    end

endmodule
