`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d_in;
    reg enable;
    wire d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .clk(clk),
        .d_in(d_in),
        .enable(enable),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable <= 0;
            d_in <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write '1'");
            reset_dut();
            test_num = test_num + 1;


            enable <= 1;
            d_in <= 1;
            @(posedge clk);
            #1;


            enable <= 0;
            d_in <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write '0'");
            reset_dut();
            test_num = test_num + 1;


            enable <= 1;
            d_in <= 0;
            @(posedge clk);
            #1;


            enable <= 0;
            d_in <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable Low (0 -> 1)");
            reset_dut();
            test_num = test_num + 1;


            enable <= 1;
            d_in <= 0;
            @(posedge clk);
            #1;


            enable <= 0;
            d_in <= 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write Enable Low (1 -> 0)");
            reset_dut();
            test_num = test_num + 1;


            enable <= 1;
            d_in <= 1;
            @(posedge clk);
            #1;


            enable <= 0;
            d_in <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data Retention Test");
            reset_dut();
            test_num = test_num + 1;


            enable <= 1;
            d_in <= 1;
            @(posedge clk);
            #1;


            enable <= 0;
            d_in <= 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sequential Toggling");
            reset_dut();
            test_num = test_num + 1;


            enable <= 1;
            d_in <= 1;
            @(posedge clk);
            #1;


            enable <= 1;
            d_in <= 0;
            @(posedge clk);
            #1;


            enable <= 1;
            d_in <= 1;
            @(posedge clk);
            #1;


            enable <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        input expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%b",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%b",
                         expected_d_out);
                $display("  Got:      d_out=%b",
                         d_out);
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
        $dumpvars(0,clk, d_in, enable, d_out);
    end

endmodule
