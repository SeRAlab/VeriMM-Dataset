`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] data;
    reg load;
    reg reset;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data(data),
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
            @(posedge clk);
            #1;
            reset = 1;
            load = 0;
            data = 12'h000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Synchronous Reset Check");

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Parallel Load Check");
            @(posedge clk);
            #1;
            load = 1;
            data = 12'hA5C;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(12'hA5C);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Single Shift-Right Check");

            @(posedge clk);
            #1;
            load = 1;
            data = 12'hAAB;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(12'h555);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Multiple Shifts Check");
            @(posedge clk);
            #1;
            load = 1;
            data = 12'h800;
            @(posedge clk);
            #1;
            load = 0;
            repeat (4) @(posedge clk);
            #1;

            #1;


            check_outputs(12'h080);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Shift until Empty Check");
            @(posedge clk);
            #1;
            load = 1;
            data = 12'h001;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Reset Priority Check");
            @(posedge clk);
            #1;
            reset = 1;
            load = 1;
            data = 12'hFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
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
        input [11:0] expected_q;
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
        $dumpvars(0,clk, data, load, reset, q);
    end

endmodule
