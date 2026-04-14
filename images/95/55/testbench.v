`timescale 1ns/1ps

module ShiftRegister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg en;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRegister dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset Check");
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Single bit shift in (1)");
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            data_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Fill register with 1s");
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            data_in = 1;
            repeat (8) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Enable signal verification");
            test_num = test_num + 1;
            reset_dut();


            en = 1; data_in = 1; @(posedge clk); #1;
            en = 1; data_in = 0; @(posedge clk); #1;


            en = 0; data_in = 1; @(posedge clk); #1;
            en = 0; data_in = 1; @(posedge clk); #1;


            #1;



            check_outputs(8'h40);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] pattern;
        begin
            $display("\nTestcase 005: Pattern shift (0x55)");
            test_num = test_num + 1;
            reset_dut();
            en = 1;


            pattern = 8'h55;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Shifting data out");
            test_num = test_num + 1;
            reset_dut();
            en = 1;

            data_in = 1;
            repeat (8) @(posedge clk);
            #1;

            data_in = 0;
            repeat (4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ShiftRegister Testbench");
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
        $dumpvars(0,clk, data_in, en, rst, q);
    end

endmodule
