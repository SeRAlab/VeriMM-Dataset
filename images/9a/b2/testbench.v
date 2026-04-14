`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst;
    reg shift_en;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift_en(shift_en),
        .q(q)
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
            load = 0;
            shift_en = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Synchronous Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load 0xAA");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Left (0x01 -> 0x02)");
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'h01;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            shift_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple Shifts (Shift 4 times)");
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'h01;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            shift_en = 1;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Left Overflow (0x80 -> 0x00)");
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'h80;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            shift_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Priority Check (Load vs Shift)");
            reset_dut();

            @(negedge clk);
            load = 1;
            shift_en = 1;
            data_in = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Hold Value (shift_en=0, load=0)");
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hCC;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            shift_en = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_8bit Testbench");
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
        $dumpvars(0,clk, data_in, load, rst, shift_en, q);
    end

endmodule
