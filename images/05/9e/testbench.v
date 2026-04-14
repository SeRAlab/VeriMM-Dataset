`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] D_in;
    reg RE;
    reg WE;
    reg [3:0] addr;
    reg clk;
    wire [15:0] D_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D_in(D_in),
        .RE(RE),
        .WE(WE),
        .addr(addr),
        .clk(clk),
        .D_out(D_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            WE = 0;
            RE = 0;
            addr = 0;
            D_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Write and Read at Address 0");
            reset_dut();


            @(posedge clk);
            WE = 1; addr = 4'h0; D_in = 16'hA5A5; RE = 0;
            @(posedge clk);
            WE = 0;


            @(posedge clk);
            RE = 1; addr = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Boundary Address Test (Address 15)");
            reset_dut();


            @(posedge clk);
            WE = 1; addr = 4'hF; D_in = 16'h5A5A; RE = 0;
            @(posedge clk);
            WE = 0;


            @(posedge clk);
            RE = 1; addr = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Overwriting Data");
            reset_dut();


            @(posedge clk);
            WE = 1; addr = 4'h7; D_in = 16'h1234;
            @(posedge clk);


            WE = 1; addr = 4'h7; D_in = 16'hFEDC;
            @(posedge clk);
            WE = 0;


            RE = 1; addr = 4'h7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFEDC);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Data Persistence");
            reset_dut();


            @(posedge clk);
            WE = 1; addr = 4'h2; D_in = 16'hAAAA;
            @(posedge clk);

            WE = 1; addr = 4'h3; D_in = 16'hBBBB;
            @(posedge clk);
            WE = 0;


            RE = 1; addr = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Write Enable (WE) Verification");
            reset_dut();


            @(posedge clk);
            WE = 1; addr = 4'hA; D_in = 16'h8888;
            @(posedge clk);


            WE = 0; addr = 4'hA; D_in = 16'h9999;
            @(posedge clk);


            RE = 1; addr = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8888);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Multiple sequential reads");
            reset_dut();


            @(posedge clk);
            WE = 1; addr = 4'h1; D_in = 16'h1111;
            @(posedge clk);
            WE = 1; addr = 4'h2; D_in = 16'h2222;
            @(posedge clk);
            WE = 0;


            RE = 1; addr = 4'h1;
            @(posedge clk);

            addr = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [15:0] expected_D_out;
        begin
            if (expected_D_out === (expected_D_out ^ D_out ^ expected_D_out)) begin
                $display("PASS");
                $display("  Outputs: D_out=%h",
                         D_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_out=%h",
                         expected_D_out);
                $display("  Got:      D_out=%h",
                         D_out);
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
        $dumpvars(0,D_in, RE, WE, addr, clk, D_out);
    end

endmodule
