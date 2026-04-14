`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .d(d),
        .load(load),
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
            load = 0;
            d = 0;
            @(posedge clk);
            #1;
            rst = 0;
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

        begin
            $display("Testcase 002: Parallel Load 0xAA");
            reset_dut();
            d = 8'hAA;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single Left Shift (0x01 -> 0x02)");
            reset_dut();

            d = 8'h01;
            load = 1;
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
            $display("Testcase 004: Multiple Left Shifts (0x01 shifted 4 times)");
            reset_dut();

            d = 8'h01;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Out (0x80 -> 0x00)");
            reset_dut();

            d = 8'h80;
            load = 1;
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
            $display("Testcase 006: Load Override Shift");
            reset_dut();

            d = 8'h55;
            load = 1;
            @(posedge clk);
            #1;

            d = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset Priority Over Load");
            reset_dut();

            d = 8'hFF;
            load = 1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: 8 Shifts Clears Register");
            reset_dut();

            d = 8'hFF;
            load = 1;
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
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, d, load, rst, q);
    end

endmodule
