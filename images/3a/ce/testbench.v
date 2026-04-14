`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data_in = 16'hA5A5;
            load = 1;
            @(posedge clk);
            #1;
            $display("Testcase 001: Parallel Load 16'hA5A5");
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            data_in = 16'h0002;
            load = 1;
            @(posedge clk);

            #1 load = 0;
            @(posedge clk);
            #1;
            $display("Testcase 002: Single Right Shift (0002 -> 0001)");
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            data_in = 16'h8000;
            load = 1;
            @(posedge clk);

            #1 load = 0;
            @(posedge clk);
            #1;
            $display("Testcase 003: MSB Zero-fill (8000 -> 4000)");
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            data_in = 16'hF000;
            load = 1;
            @(posedge clk);

            #1 load = 0;
            repeat(4) @(posedge clk);
            #1;
            $display("Testcase 004: Four Right Shifts (F000 -> 0F00)");
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            data_in = 16'hFFFF;
            load = 1;
            @(posedge clk);

            #1 reset = 1;
            data_in = 16'h1234;
            @(posedge clk);
            #1;
            $display("Testcase 005: Reset Priority Check");
            #1;

            check_outputs(16'h0000);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            data_in = 16'hFFFF;
            load = 1;
            @(posedge clk);

            #1 load = 0;
            repeat(16) @(posedge clk);
            #1;
            $display("Testcase 006: Shift all bits out (FFFF -> 0000)");
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            data_in = 16'h0000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1;
            $display("Testcase 007: Shift empty register");
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, data_in, load, reset, q);
    end

endmodule
