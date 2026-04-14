`timescale 1ns/1ps

module clock_switch4_basic_tb;

    // Testbench signals (sequential circuit)
    reg clk0_i;
    reg clk1_i;
    reg clk2_i;
    reg clk3_i;
    reg enable;
    reg rst0_i;
    reg rst1_i;
    reg rst2_i;
    reg rst3_i;
    reg [1:0] select;
    wire clk_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_switch4_basic dut (
        .clk0_i(clk0_i),
        .clk1_i(clk1_i),
        .clk2_i(clk2_i),
        .clk3_i(clk3_i),
        .enable(enable),
        .rst0_i(rst0_i),
        .rst1_i(rst1_i),
        .rst2_i(rst2_i),
        .rst3_i(rst3_i),
        .select(select),
        .clk_o(clk_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk0_i = 0;
        forever #5 clk0_i = ~clk0_i;
    end

        task reset_dut;

        begin
            rst0_i = 1; rst1_i = 1; rst2_i = 1; rst3_i = 1;
            enable = 0;
            select = 2'b00;
            #50;
            rst0_i = 0; rst1_i = 0; rst2_i = 0; rst3_i = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            select = 2'b00;
            enable = 1;

            #100;
            wait(clk0_i == 1);
            #1;
            $display("Testcase 001: Selecting clk0...");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            select = 2'b01;
            enable = 1;
            #100;
            wait(clk1_i == 1);
            #1;
            $display("Testcase 002: Selecting clk1...");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            select = 2'b10;
            enable = 1;
            #100;
            wait(clk2_i == 1);
            #1;
            $display("Testcase 003: Selecting clk2...");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            select = 2'b11;
            enable = 1;
            #100;
            wait(clk3_i == 1);
            #1;
            $display("Testcase 004: Selecting clk3...");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            select = 2'b00;
            enable = 0;
            #100;
            $display("Testcase 005: Testing Disable (enable=0)...");

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            select = 2'b00;
            enable = 1;
            #50;
            rst0_i = 1;
            #20;
            $display("Testcase 006: Resetting active clock path...");
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_switch4_basic Testbench");
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
        input expected_clk_o;
        begin
            if (expected_clk_o === (expected_clk_o ^ clk_o ^ expected_clk_o)) begin
                $display("PASS");
                $display("  Outputs: clk_o=%b",
                         clk_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_o=%b",
                         expected_clk_o);
                $display("  Got:      clk_o=%b",
                         clk_o);
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
        $dumpvars(0,clk0_i, clk1_i, clk2_i, clk3_i, enable, rst0_i, rst1_i, rst2_i, rst3_i, select, clk_o);
    end

endmodule
