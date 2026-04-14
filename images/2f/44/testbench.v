`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .ce(ce),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        ce = 0;
        forever #5 ce = ~ce;
    end

        task reset_dut;

        begin


            we = 1;
            data_in = 8'h00;

            @(posedge ce);
            #2;
            we = 0;
            @(posedge ce);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Writing 0xAA and reading back...");
            we = 1;
            data_in = 8'hAA;
            @(posedge ce);
            #2;
            we = 0;
            @(posedge ce);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Writing 0x55 and reading back...");
            we = 1;
            data_in = 8'h55;
            @(posedge ce);
            #2;
            we = 0;
            @(posedge ce);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Verifying write enable (we) functionality...");

            we = 1;
            data_in = 8'h12;
            @(posedge ce);
            #2;

            we = 0;
            data_in = 8'hFF;
            @(posedge ce);
            #2;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Testing all bits high (0xFF)...");
            we = 1;
            data_in = 8'hFF;
            @(posedge ce);
            #2;
            we = 0;
            @(posedge ce);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Testing all bits low (0x00)...");

            we = 1;
            data_in = 8'hFF;
            @(posedge ce);
            #2;

            data_in = 8'h00;
            @(posedge ce);
            #2;
            we = 0;
            @(posedge ce);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Persistence check over multiple cycles...");
            we = 1;
            data_in = 8'h3C;
            @(posedge ce);
            #2;
            we = 0;

            repeat(3) @(posedge ce);
            #2;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,ce, data_in, we, data_out);
    end

endmodule
