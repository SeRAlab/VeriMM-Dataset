`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg dir;
    reg en;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .d(d),
        .dir(dir),
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
            @(posedge clk);
            rst = 1;
            en = 0;
            d = 0;
            dir = 0;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Synchronous Reset");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Testcase 002: Right Shift 8 bits (All 1s)");
            reset_dut();
            en = 1;
            dir = 1;
            d = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Left Shift 8 bits (All 1s)");
            reset_dut();
            en = 1;
            dir = 0;
            d = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Enable Signal Check");
            reset_dut();
            en = 1;
            dir = 1;
            d = 1;

            for (i = 0; i < 4; i = i + 1) @(posedge clk);

            en = 0;
            for (i = 0; i < 4; i = i + 1) @(posedge clk);

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Right Shift Pattern 0xB1");
            reset_dut();
            en = 1; dir = 1;
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 0; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            #1;

            check_outputs(8'h8D);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Left Shift Pattern 10101010");
            reset_dut();
            en = 1; dir = 0;
            for (i = 0; i < 4; i = i + 1) begin
                d = 0; @(posedge clk);
                d = 1; @(posedge clk);
            end
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
        $display("shift_register_8bit Testbench");
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
        $dumpvars(0,clk, d, dir, en, rst, q);
    end

endmodule
