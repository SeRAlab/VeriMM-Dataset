`timescale 1ns/1ps

module verified_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst_n;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    verified_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst_n(rst_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Verification");
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load 0xA5");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load 0x01 and Shift Left Once");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data_in = 8'h01;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load 0x07 and Shift Left 3 times");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data_in = 8'h07;
            @(posedge clk);
            #1;
            load = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h38);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load 0x80 and Shift Left (MSB to 0)");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data_in = 8'h80;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify Load priority over Shift");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #1;

            data_in = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Load 0xFF and Shift Left 8 times");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1;
            load = 0;
            repeat(8) @(posedge clk);
            #1;
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
        $display("verified_shift_register Testbench");
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
        $dumpvars(0,clk, data_in, load, rst_n, q);
    end

endmodule
