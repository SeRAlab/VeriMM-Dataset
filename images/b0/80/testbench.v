`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] pdata;
    reg pload;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .pdata(pdata),
        .pload(pload),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pload = 1;
            pdata = 8'h00;
            @(posedge clk);
            pload = 0;
            pdata = 8'h00;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Parallel Load");
            reset_dut();
            pload = 1;
            pdata = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Shift Left");
            reset_dut();

            pload = 1;
            pdata = 8'h01;
            @(posedge clk);

            pload = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple Shifts Left (4 positions)");
            reset_dut();

            pload = 1;
            pdata = 8'h03;
            @(posedge clk);

            pload = 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h30);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift MSB Out");
            reset_dut();

            pload = 1;
            pdata = 8'h80;
            @(posedge clk);

            pload = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load Priority Over Shift");
            reset_dut();

            pload = 1;
            pdata = 8'h55;
            @(posedge clk);

            pload = 1;
            pdata = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift through entire 8-bit range");
            reset_dut();
            pload = 1;
            pdata = 8'h01;
            @(posedge clk);
            pload = 0;
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h80);
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
        $dumpvars(0,clk, pdata, pload, q);
    end

endmodule
