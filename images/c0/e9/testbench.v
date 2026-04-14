`timescale 1ns/1ps

module fm_cmn_bram_01_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg clk;
    reg [31:0] di;
    reg [1:0] dpra;
    reg we;
    wire [31:0] dpo;
    wire [31:0] spo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fm_cmn_bram_01 dut (
        .a(a),
        .clk(clk),
        .di(di),
        .dpra(dpra),
        .we(we),
        .dpo(dpo),
        .spo(spo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            di = 0;
            dpra = 0;
            we = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read-back");
            reset_dut();


            we = 1; a = 0; di = 32'hAAAA_BBBB;
            @(posedge clk); #1;


            we = 0; a = 0; dpra = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(32'hAAAA_BBBB, 32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Dual Port Simultaneous Read");
            reset_dut();


            we = 1; a = 1; di = 32'h1111_1111;
            @(posedge clk); #1;


            we = 1; a = 2; di = 32'h2222_2222;
            @(posedge clk); #1;


            we = 0; a = 1; dpra = 2;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h2222_2222, 32'h1111_1111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write-Through Logic Verification");
            reset_dut();


            we = 1; a = 3; di = 32'hCAFE_BABE; dpra = 0;
            @(posedge clk); #1;



            #1;




            check_outputs(32'h0000_0000, 32'hCAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Independent Port Access");
            reset_dut();


            we = 1; a = 2; di = 32'h5555_6666;
            @(posedge clk); #1;


            we = 1; a = 1; di = 32'hEEEE_FFFF; dpra = 2;
            @(posedge clk); #1;


            #1;



            check_outputs(32'h5555_6666, 32'hEEEE_FFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting and Persistence");
            reset_dut();


            we = 1; a = 0; di = 32'h1234_5678;
            @(posedge clk); #1;


            we = 1; a = 0; di = 32'h8765_4321;
            @(posedge clk); #1;


            we = 0; a = 0; dpra = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h8765_4321, 32'h8765_4321);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fm_cmn_bram_01 Testbench");
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
        input [31:0] expected_dpo;
        input [31:0] expected_spo;
        begin
            if (expected_dpo === (expected_dpo ^ dpo ^ expected_dpo) &&
                expected_spo === (expected_spo ^ spo ^ expected_spo)) begin
                $display("PASS");
                $display("  Outputs: dpo=%h, spo=%h",
                         dpo, spo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dpo=%h, spo=%h",
                         expected_dpo, expected_spo);
                $display("  Got:      dpo=%h, spo=%h",
                         dpo, spo);
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
        $dumpvars(0,a, clk, di, dpra, we, dpo, spo);
    end

endmodule
