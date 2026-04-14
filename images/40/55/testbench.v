`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg read_en;
    reg write_en;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .din(din),
        .read_en(read_en),
        .write_en(write_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        din = 16'h0000;
        read_en = 0;
        write_en = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Checking if initial state is zero...");
        reset_dut();
        read_en = 1;
        @(negedge clk);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Basic Write (0xABCD) and Read...");
        reset_dut();


        din = 16'hABCD;
        write_en = 1;
        @(negedge clk);
        write_en = 0;


        read_en = 1;
        @(negedge clk);
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Overwriting existing data (0x1111 -> 0x2222)...");
        reset_dut();


        din = 16'h1111;
        write_en = 1;
        @(negedge clk);


        din = 16'h2222;
        write_en = 1;
        @(negedge clk);
        write_en = 0;


        read_en = 1;
        @(negedge clk);
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Ensuring write_en=0 does not update cell...");
        reset_dut();


        din = 16'h5555;
        write_en = 1;
        @(negedge clk);


        write_en = 0;
        din = 16'hAAAA;
        @(negedge clk);


        read_en = 1;
        @(negedge clk);
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Simultaneous Read and Write (0xCAFE)...");
        reset_dut();


        din = 16'hCAFE;
        write_en = 1;
        read_en = 1;
        @(negedge clk);


        #1;



        check_outputs(16'hCAFE);
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
        input [15:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, read_en, write_en, dout);
    end

endmodule
