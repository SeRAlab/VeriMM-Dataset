`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr1;
    reg [1:0] addr2;
    reg clock;
    reg [1:0] data1;
    reg [1:0] data2;
    reg we1;
    reg we2;
    wire [1:0] out1;
    wire [1:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clock(clock),
        .data1(data1),
        .data2(data2),
        .we1(we1),
        .we2(we2),
        .out1(out1),
        .out2(out2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        addr1 = 2'b0;
        addr2 = 2'b0;
        data1 = 2'b0;
        data2 = 2'b0;
        we1 = 1'b0;
        we2 = 1'b0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        addr1 = 2'd1; data1 = 2'b11; we1 = 1'b1;
        @(posedge clock);
        #1 we1 = 1'b0;


        addr1 = 2'd1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        addr2 = 2'd3; data2 = 2'b10; we2 = 1'b1;
        @(posedge clock);
        #1 we2 = 1'b0;


        addr2 = 2'd3;
        @(posedge clock);
        #1;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        addr1 = 2'd0; data1 = 2'b01; we1 = 1'b1;
        addr2 = 2'd2; data2 = 2'b11; we2 = 1'b1;
        @(posedge clock);
        #1 we1 = 1'b0; we2 = 1'b0;


        addr1 = 2'd0; addr2 = 2'd2;
        @(posedge clock);
        #1;
        #1;

        check_outputs(2'b01, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        addr1 = 2'd1; data1 = 2'b11; we1 = 1'b0;
        @(posedge clock);
        #1;


        addr1 = 2'd1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        addr1 = 2'd0; data1 = 2'b01; we1 = 1'b1;
        @(posedge clock);
        #1 addr1 = 2'd1; data1 = 2'b10; we1 = 1'b1;
        @(posedge clock);
        #1 we1 = 1'b0;


        addr1 = 2'd0;
        @(posedge clock);
        #1;

        if (out1 === 2'b01) begin
            addr1 = 2'd1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(2'b10, 2'b00);
        end else begin
            #1;

            check_outputs(2'b01, 2'b00);
        end
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        addr1 = 2'd2; data1 = 2'b11; we1 = 1'b1;
        addr2 = 2'd2; data2 = 2'b01; we2 = 1'b1;
        @(posedge clock);
        #1 we1 = 1'b0; we2 = 1'b0;


        addr1 = 2'd2; addr2 = 2'd2;
        @(posedge clock);
        #1;
        #1;

        check_outputs(2'b11, 2'b01);
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
        input [1:0] expected_out1;
        input [1:0] expected_out2;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
        $dumpvars(0,addr1, addr2, clock, data1, data2, we1, we2, out1, out2);
    end

endmodule
