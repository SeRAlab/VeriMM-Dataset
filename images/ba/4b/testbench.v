`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ADDR_W;
    reg CLK;
    reg [7:0] DATA_W;
    reg RSTn;
    reg WR;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR_W(ADDR_W),
        .CLK(CLK),
        .DATA_W(DATA_W),
        .RSTn(RSTn),
        .WR(WR),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RSTn = 1;
        WR = 0;
        ADDR_W = 0;
        DATA_W = 0;
        #2 RSTn = 0;
        #10 RSTn = 1;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test %0d: Reset verification", test_num);
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test %0d: Write to ADDR 0", test_num);
        @(posedge CLK);
        WR = 1;
        ADDR_W = 4'h0;
        DATA_W = 8'hAA;
        @(posedge CLK);
        WR = 0;
        #1;
        #1;

        check_outputs({120'h0, 8'hAA});
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test %0d: Write to ADDR 15", test_num);
        @(posedge CLK);
        WR = 1;
        ADDR_W = 4'hF;
        DATA_W = 8'h55;
        @(posedge CLK);
        WR = 0;
        #1;
        #1;

        check_outputs({8'h55, 120'h0});
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test %0d: Multiple Sequential Writes", test_num);

        @(posedge CLK);
        WR = 1; ADDR_W = 4'h1; DATA_W = 8'h11;

        @(posedge CLK);
        WR = 1; ADDR_W = 4'h2; DATA_W = 8'h22;

        @(posedge CLK);
        WR = 1; ADDR_W = 4'h3; DATA_W = 8'h33;
        @(posedge CLK);
        WR = 0;
        #1;

        #1;


        check_outputs({96'h0, 8'h33, 8'h22, 8'h11, 8'h00});
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test %0d: Overwrite check", test_num);
        @(posedge CLK);
        WR = 1; ADDR_W = 4'h5; DATA_W = 8'hA1;
        @(posedge CLK);
        WR = 1; ADDR_W = 4'h5; DATA_W = 8'hB2;
        @(posedge CLK);
        WR = 0;
        #1;

        #1;


        check_outputs({80'h0, 8'hB2, 40'h0});
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Test %0d: Write Enable Disable check", test_num);
        @(posedge CLK);
        WR = 0;
        ADDR_W = 4'h7;
        DATA_W = 8'hFF;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase007;

    reg [127:0] expected;
    integer i;
    begin
        test_num = 7;
        reset_dut();
        $display("Test %0d: Fill all registers", test_num);
        expected = 0;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge CLK);
            WR = 1;
            ADDR_W = i;
            DATA_W = i + 8'h10;
            expected[(i*8) +: 8] = i + 8'h10;
        end
        @(posedge CLK);
        WR = 0;
        #1;
        #1;

        check_outputs(expected);
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
        input [127:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,ADDR_W, CLK, DATA_W, RSTn, WR, data_out);
    end

endmodule
