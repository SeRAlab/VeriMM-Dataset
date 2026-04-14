`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] ADDR;
    reg [7:0] D;
    reg RE;
    reg WE;
    reg clk;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .ADDR(ADDR),
        .D(D),
        .RE(RE),
        .WE(WE),
        .clk(clk),
        .Q(Q)
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
            ADDR = 0;
            D = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Basic Write and Read");


            @(posedge clk);
            WE = 1; RE = 0; ADDR = 8'h01; D = 8'hA5;


            @(posedge clk);
            WE = 0; RE = 1; ADDR = 8'h01;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Boundary Address 0xFF");

            @(posedge clk);
            WE = 1; RE = 0; ADDR = 8'hFF; D = 8'h5A;

            @(posedge clk);
            WE = 0; RE = 1; ADDR = 8'hFF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Overwrite existing data");


            @(posedge clk);
            WE = 1; RE = 0; ADDR = 8'h10; D = 8'h11;


            @(posedge clk);
            D = 8'h22;

            @(posedge clk);
            WE = 0; RE = 1; ADDR = 8'h10;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Address Isolation Check");


            @(posedge clk);
            WE = 1; ADDR = 8'h0A; D = 8'hAA;


            @(posedge clk);
            ADDR = 8'h0B; D = 8'hBB;


            @(posedge clk);
            WE = 0; RE = 1; ADDR = 8'h0A;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Write Enable logic check");


            @(posedge clk);
            WE = 1; ADDR = 8'h20; D = 8'hCC;


            @(posedge clk);
            WE = 0; ADDR = 8'h20; D = 8'hDD;


            @(posedge clk);
            RE = 1; ADDR = 8'h20;

            @(posedge clk);
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
        $display("dram_cell Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,ADDR, D, RE, WE, clk, Q);
    end

endmodule
