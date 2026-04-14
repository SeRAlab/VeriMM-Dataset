`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [31:0] wdata;
    reg we;
    wire [31:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .addr(addr),
        .clk(clk),
        .wdata(wdata),
        .we(we),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 4'b0;
            wdata = 32'b0;
            we = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write/Read at Address 0");
            reset_dut();


            addr = 4'h0;
            wdata = 32'hAAAA_BBBB;
            we = 1'b1;
            @(posedge clk);
            #1;


            we = 1'b0;
            addr = 4'h0;
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write/Read at Address 15");
            reset_dut();


            addr = 4'hF;
            wdata = 32'h1234_5678;
            we = 1'b1;
            @(posedge clk);
            #1;


            we = 1'b0;
            addr = 4'hF;
            #1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify Write Enable functionality");
            reset_dut();


            addr = 4'h5;
            wdata = 32'hFFFF_FFFF;
            we = 1'b1;
            @(posedge clk);
            #1;


            wdata = 32'h0000_0000;
            we = 1'b0;
            @(posedge clk);
            #1;


            addr = 4'h5;
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwrite value in address 7");
            reset_dut();


            addr = 4'h7;
            wdata = 32'h1111_1111;
            we = 1'b1;
            @(posedge clk);
            #1;


            wdata = 32'h2222_2222;
            @(posedge clk);
            #1;

            we = 1'b0;
            #1;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data persistence (isolation check)");
            reset_dut();


            addr = 4'h1;
            wdata = 32'hDEAD_BEEF;
            we = 1'b1;
            @(posedge clk);
            #1;


            addr = 4'h2;
            wdata = 32'hCAFE_BABE;
            @(posedge clk);
            #1;


            we = 1'b0;
            addr = 4'h1;
            #1;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_file Testbench");
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
        input [31:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,addr, clk, wdata, we, rdata);
    end

endmodule
