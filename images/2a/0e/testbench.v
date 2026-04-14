`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data;
    reg rst;
    reg we;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .data(data),
        .rst(rst),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        rst = 0;
        forever #5 rst = ~rst;
    end

        task reset_dut;

        begin
            rst = 1;
            we = 0;
            data = 8'h00;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read (8'hAA)");
            reset_dut();
            test_num = test_num + 1;
            we = 1;
            data = 8'hAA;
            #20;
            we = 0;
            #20;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Data Retention (we=0)");
            reset_dut();
            test_num = test_num + 1;

            we = 1;
            data = 8'h55;
            #20;

            we = 0;
            data = 8'hFF;
            #20;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Manual Reset during operation");
            reset_dut();
            test_num = test_num + 1;

            we = 1;
            data = 8'hFF;
            #20;

            rst = 1;
            #20;
            rst = 0;
            we = 0;
            #20;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write Disabled (we=0) from reset");
            reset_dut();
            test_num = test_num + 1;

            we = 0;
            data = 8'hCC;
            #20;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Write Boundary Value (8'hFF)");
            reset_dut();
            test_num = test_num + 1;
            we = 1;
            data = 8'hFF;
            #20;
            we = 0;
            #20;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Write Boundary Value (8'h00)");
            reset_dut();
            test_num = test_num + 1;

            we = 1;
            data = 8'hA5;
            #20;

            data = 8'h00;
            #20;
            we = 0;
            #20;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,data, rst, we, q);
    end

endmodule
