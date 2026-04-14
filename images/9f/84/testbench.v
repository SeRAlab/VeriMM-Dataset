`timescale 1ns/1ps

module register_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg enable;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_4bit dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            d = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Basic Load Operation (d=4'hA, enable=1)");
            reset_dut();

            d = 4'hA;
            enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Enable Signal Logic (d=4'hF, enable=0)");
            reset_dut();


            d = 4'h5;
            enable = 1;
            @(posedge clk);


            d = 4'hF;
            enable = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Boundary Values (All 1s then All 0s)");
            reset_dut();


            d = 4'hF;
            enable = 1;
            @(posedge clk);


            d = 4'h0;
            enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Data Stability (Hold value for 3 cycles)");
            reset_dut();


            d = 4'hC;
            enable = 1;
            @(posedge clk);


            enable = 0;
            d = 4'h1; @(posedge clk);
            d = 4'h2; @(posedge clk);
            d = 4'h3; @(posedge clk);
            #2;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Consecutive Updates");
            reset_dut();

            enable = 1;
            d = 4'h1; @(posedge clk);
            d = 4'h2; @(posedge clk);
            d = 4'h4; @(posedge clk);
            d = 4'h8; @(posedge clk);
            #2;

            #1;


            check_outputs(4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        $dumpvars(0,clk, d, enable, q);
    end

endmodule
