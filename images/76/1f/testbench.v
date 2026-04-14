`timescale 1ns/1ps

module rising_edge_capturer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] in;
    reg reset_n;
    wire [11:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rising_edge_capturer dut (
        .clk(clk),
        .in(in),
        .reset_n(reset_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            in = 12'h000;
            @(posedge clk);
            #1 reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Single bit (0) rising edge...");
            reset_dut();
            test_num = test_num + 1;
            in = 12'h000;
            @(posedge clk);
            #1 in = 12'h001;
            @(posedge clk);
            #1 #1;
 check_outputs(12'h001);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: All bits rising edge...");
            reset_dut();
            test_num = test_num + 1;
            in = 12'h000;
            @(posedge clk);
            #1 in = 12'hFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Falling edge (no capture)...");
            reset_dut();
            test_num = test_num + 1;
            in = 12'hFFF;
            @(posedge clk);
            #1 in = 12'h000;
            @(posedge clk);
            #1 #1;
 check_outputs(12'h000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Sustained high level (no repeat capture)...");
            reset_dut();
            test_num = test_num + 1;
            in = 12'hAAA;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1 #1;
 check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Mixed 0->1 and 1->0 transitions...");
            reset_dut();
            test_num = test_num + 1;
            in = 12'h555;
            @(posedge clk);
            #1 in = 12'hAAA;
            @(posedge clk);
            #1 #1;
 check_outputs(12'hAAA);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Synchronous Reset priority...");
            reset_dut();
            test_num = test_num + 1;
            in = 12'h000;
            @(posedge clk);
            #1 in = 12'hFFF;
            reset_n = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(12'h000);
            reset_n = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rising_edge_capturer Testbench");
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
        input [11:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, reset_n, out);
    end

endmodule
