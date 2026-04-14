`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg [5:0] adpcma_flags;
    reg adpcmb_flag;
    reg busy;
    reg clk;
    reg flag_A;
    reg flag_B;
    reg [7:0] psg_dout;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .adpcma_flags(adpcma_flags),
        .adpcmb_flag(adpcmb_flag),
        .busy(busy),
        .clk(clk),
        .flag_A(flag_A),
        .flag_B(flag_B),
        .psg_dout(psg_dout),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            adpcma_flags = 0;
            adpcmb_flag = 0;
            busy = 0;
            flag_A = 0;
            flag_B = 0;
            psg_dout = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            addr = 2'b00;
            busy = 1'b1;
            flag_A = 1'b1;
            flag_B = 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'b10000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            addr = 2'b00;
            busy = 1'b0;
            flag_A = 1'b0;
            flag_B = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'b00000010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            addr = 2'b01;
            psg_dout = 8'hAA;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            addr = 2'b10;
            adpcmb_flag = 1'b1;
            adpcma_flags = 6'b101010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'b10101010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            addr = 2'b11;
            adpcmb_flag = 1'b0;
            adpcma_flags = 6'b011111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'b00011111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            addr = 2'b01;
            psg_dout = 8'h55;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55);
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
        input [7:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, adpcma_flags, adpcmb_flag, busy, clk, flag_A, flag_B, psg_dout, dout);
    end

endmodule
