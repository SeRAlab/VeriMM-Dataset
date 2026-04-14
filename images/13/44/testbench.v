`timescale 1ns/1ps

module sram_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] din;
    reg we;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_16bit dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write/Read at Address 0");
            test_num = 1;
            reset_dut();


            we = 1; addr = 4'h0; din = 16'hAAAA;
            @(posedge clk); #1;


            we = 0; addr = 4'h0;
            @(posedge clk); #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write/Read at Address 15");
            test_num = 2;
            reset_dut();


            we = 1; addr = 4'hF; din = 16'h5555;
            @(posedge clk); #1;


            we = 0; addr = 4'hF;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwrite Data at Address 7");
            test_num = 3;
            reset_dut();


            we = 1; addr = 4'h7; din = 16'h1234;
            @(posedge clk); #1;


            we = 1; addr = 4'h7; din = 16'h9876;
            @(posedge clk); #1;


            we = 0; addr = 4'h7;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h9876);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write Enable Control Check");
            test_num = 4;
            reset_dut();


            we = 1; addr = 4'hA; din = 16'hC0DE;
            @(posedge clk); #1;


            we = 0; addr = 4'hA; din = 16'hDEAD;
            @(posedge clk); #1;


            we = 0; addr = 4'hA;
            @(posedge clk); #1;

            #1;


            check_outputs(16'hC0DE);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Address Independence Check");
            test_num = 5;
            reset_dut();


            we = 1; addr = 4'h1; din = 16'h1111;
            @(posedge clk); #1;


            we = 1; addr = 4'h2; din = 16'h2222;
            @(posedge clk); #1;


            we = 0; addr = 4'h1;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h1111);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Full Data Width (0xFFFF) Check");
            test_num = 6;
            reset_dut();

            we = 1; addr = 4'h8; din = 16'hFFFF;
            @(posedge clk); #1;

            we = 0; addr = 4'h8;
            @(posedge clk); #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_16bit Testbench");
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
        $dumpvars(0,addr, clk, din, we, dout);
    end

endmodule
