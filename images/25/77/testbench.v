`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] seed;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Seed 0x1, Shift 1 cycle", test_num);
            seed = 32'h0000_0001;
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0000_0003);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Seed 0x1, Shift 5 cycles", test_num);
            seed = 32'h0000_0001;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_003F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Seed 0x80000000 (Bit 31 set)", test_num);
            seed = 32'h8000_0000;
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Seed 0x00200000 (Bit 21 set)", test_num);
            seed = 32'h0020_0000;
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0040_0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Seed 0x00100000 (Bit 20 set)", test_num);
            seed = 32'h0010_0000;
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0020_0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Seed 0x80200001 (Bits 31, 21, 0 set)", test_num);
            seed = 32'h8020_0001;
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0040_0003);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Seed 0xFFFFFFFF", test_num);
            seed = 32'hFFFF_FFFF;
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hFFFF_FFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Seed 0x00000000", test_num);
            seed = 32'h0000_0000;
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Seed 0xAAAAAAAA", test_num);
            seed = 32'hAAAA_AAAA;
            reset_dut();
            @(posedge clk);
            #1;



            #1;




            check_outputs(32'h5555_5554);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Seed 0x00000001, Shift 31 times", test_num);
            seed = 32'h0000_0001;
            reset_dut();

            repeat(31) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h7FFF_FFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_lfsr_out;
        begin
            if (expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: lfsr_out=%h",
                         lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr_out=%h",
                         expected_lfsr_out);
                $display("  Got:      lfsr_out=%h",
                         lfsr_out);
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
        $dumpvars(0,clk, rst, seed, lfsr_out);
    end

endmodule
