`timescale 1ns/1ps

module d_flip_flop_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg en;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_flip_flop_4bit dut (
        .clk(clk),
        .d(d),
        .en(en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            d = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Data Capture");
            reset_dut();
            test_num = 1;

            en = 1;
            d = 4'b1010;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Enable Gating (Hold value)");
            reset_dut();
            test_num = 2;


            en = 1;
            d = 4'hF;
            @(posedge clk);
            #1;


            en = 0;
            d = 4'h0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Successive Writes");
            reset_dut();
            test_num = 3;

            en = 1;
            d = 4'h5;
            @(posedge clk);
            #1;

            d = 4'h3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Data Change Without Clock Edge");
            reset_dut();
            test_num = 4;

            en = 1;
            d = 4'h7;
            @(posedge clk);
            #1;


            d = 4'hB;
            #2;


            #1;



            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Boundary Value (All Ones)");
            reset_dut();
            test_num = 5;

            en = 1;
            d = 4'b1111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Toggle Enable");
            reset_dut();
            test_num = 6;


            en = 1; d = 4'hC;
            @(posedge clk); #1;


            en = 0; d = 4'h2;
            @(posedge clk); #1;


            en = 1; d = 4'hE;
            @(posedge clk); #1;

            #1;


            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_flip_flop_4bit Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, d, en, q);
    end

endmodule
