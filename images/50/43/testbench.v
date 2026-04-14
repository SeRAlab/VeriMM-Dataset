`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c;
    reg [7:0] d;
    reg dv;
    reg rst;
    wire [15:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .d(d),
        .dv(dv),
        .rst(rst),
        .crc(crc)
    );

    // Clock generation (10ns period)
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

        task reset_dut;

        begin
            rst = 1;
            dv = 0;
            d = 8'h00;
            @(posedge c);
            #2;
            rst = 0;
            @(posedge c);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Post-Reset State (Initial CRC 0xFFFF inverted)", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single byte 0x00", test_num);
            reset_dut();
            d = 8'h00;
            dv = 1;
            @(posedge c);
            #2;
            dv = 0;

            #1;


            check_outputs(16'h4FFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Single byte 0xFF", test_num);
            reset_dut();
            d = 8'hFF;
            dv = 1;
            @(posedge c);
            #2;
            dv = 0;

            #1;


            check_outputs(16'h8FFE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Multi-byte 0x00, 0x01", test_num);
            reset_dut();

            d = 8'h00; dv = 1; @(posedge c); #2;
            d = 8'h01; dv = 1; @(posedge c); #2;
            dv = 0;

            #1;


            check_outputs(16'h2F00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Data Valid (dv) signal gating", test_num);
            reset_dut();

            d = 8'h00; dv = 1; @(posedge c); #2;
            d = 8'hFF; dv = 0; @(posedge c); #2;
            d = 8'h01; dv = 1; @(posedge c); #2;
            dv = 0;

            #1;


            check_outputs(16'h2F00);
        end
        endtask

    task testcase006;

        reg [7:0] msg [0:3];
        integer i;
        begin
            test_num = 6;
            $display("Test %0d: Sequence 0x12, 0x34, 0x56, 0x78", test_num);
            reset_dut();
            msg[0] = 8'h12; msg[1] = 8'h34; msg[2] = 8'h56; msg[3] = 8'h78;

            for(i = 0; i < 4; i = i + 1) begin
                d = msg[i]; dv = 1; @(posedge c); #2;
            end
            dv = 0;

            #1;


            check_outputs(16'hC209);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Reset during operation", test_num);
            reset_dut();

            d = 8'hAA; dv = 1; @(posedge c); #2;
            d = 8'hBB; dv = 1; @(posedge c); #2;


            rst = 1; @(posedge c); #2; rst = 0;

            d = 8'h00; dv = 1; @(posedge c); #2;
            dv = 0;

            #1;


            check_outputs(16'h4FFE);
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
        input [15:0] expected_crc;
        begin
            if (expected_crc === (expected_crc ^ crc ^ expected_crc)) begin
                $display("PASS");
                $display("  Outputs: crc=%h",
                         crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc=%h",
                         expected_crc);
                $display("  Got:      crc=%h",
                         crc);
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
        $dumpvars(0,c, d, dv, rst, crc);
    end

endmodule
