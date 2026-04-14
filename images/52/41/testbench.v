`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BITVAL;
    reg CLK;
    reg Enable;
    reg RST;
    wire [15:0] CRC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BITVAL(BITVAL),
        .CLK(CLK),
        .Enable(Enable),
        .RST(RST),
        .CRC(CRC)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        BITVAL = 0;
        Enable = 0;
        @(posedge CLK);
        #1;
        RST = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task send_bit;

        input bit_in;
        begin
            BITVAL = bit_in;
            Enable = 1;
            @(posedge CLK);
            #1;
            Enable = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset State Verification", test_num);
        reset_dut();


        #1;



        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit '1' Input", test_num);
        reset_dut();
        send_bit(1'b1);

        #1;


        check_outputs(16'h1021);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test %0d: 16-bit Zero Sequence", test_num);
        reset_dut();
        for(i=0; i<16; i=i+1) begin
            send_bit(1'b0);
        end
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4-bit Pattern (1011)", test_num);
        reset_dut();
        send_bit(1'b1);
        send_bit(1'b0);
        send_bit(1'b1);
        send_bit(1'b1);
        #1;

        check_outputs(16'hB16B);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable Gating Verification", test_num);
        reset_dut();


        send_bit(1'b1);


        BITVAL = 1'b0;
        Enable = 0;
        repeat(5) @(posedge CLK);
        #1;


        send_bit(1'b0);


        #1;



        check_outputs(16'h2042);
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
        input [15:0] expected_CRC;
        begin
            if (expected_CRC === (expected_CRC ^ CRC ^ expected_CRC)) begin
                $display("PASS");
                $display("  Outputs: CRC=%h",
                         CRC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CRC=%h",
                         expected_CRC);
                $display("  Got:      CRC=%h",
                         CRC);
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
        $dumpvars(0,BITVAL, CLK, Enable, RST, CRC);
    end

endmodule
