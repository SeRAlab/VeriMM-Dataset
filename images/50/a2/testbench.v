`timescale 1ns/1ps

module shift_reg8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg si;
    wire [7:0] po;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg8 dut (
        .clk(clk),
        .rst(rst),
        .si(si),
        .po(po)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            si = 0;
            @(negedge clk);
            rst = 0;
            #1;
        end
        endtask
    task shift_byte;

        input [7:0] data;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                si = data[i];
            end

            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Full 1s (0xFF)");
            reset_dut();
            shift_byte(8'hFF);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Pattern 0xAA");
            reset_dut();
            shift_byte(8'hAA);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Pattern 0x55");
            reset_dut();
            shift_byte(8'h55);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Pattern 0xA5");
            reset_dut();
            shift_byte(8'hA5);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg8 Testbench");
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
        input [7:0] expected_po;
        begin
            if (expected_po === (expected_po ^ po ^ expected_po)) begin
                $display("PASS");
                $display("  Outputs: po=%h",
                         po);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: po=%h",
                         expected_po);
                $display("  Got:      po=%h",
                         po);
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
        $dumpvars(0,clk, rst, si, po);
    end

endmodule
