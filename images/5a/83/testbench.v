`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [7:0] din;
    reg we;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
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
            $display("Testcase 001: Basic Write and Read at Address 0");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            we = 1;
            addr = 4'h0;
            din = 8'hAA;


            @(negedge clk);
            we = 0;
            addr = 4'h0;


            @(negedge clk);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read at Address 0xF");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            we = 1;
            addr = 4'hF;
            din = 8'h55;

            @(negedge clk);
            we = 0;
            addr = 4'hF;

            @(negedge clk);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwriting Address 0x5");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            we = 1;
            addr = 4'h5;
            din = 8'h11;


            @(negedge clk);
            we = 1;
            addr = 4'h5;
            din = 8'h22;


            @(negedge clk);
            we = 0;
            addr = 4'h5;

            @(negedge clk);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verification of address independence (Write 0x3 to A, 0x4 to B)");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            we = 1;
            addr = 4'h1;
            din = 8'h33;


            @(negedge clk);
            we = 1;
            addr = 4'h2;
            din = 8'h44;


            @(negedge clk);
            we = 0;
            addr = 4'h1;

            @(negedge clk);
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify WE logic (Disable write)");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            we = 1;
            addr = 4'h7;
            din = 8'h77;


            @(negedge clk);
            we = 0;
            addr = 4'h7;
            din = 8'hFF;


            @(negedge clk);
            we = 0;
            addr = 4'h7;

            @(negedge clk);
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating Read/Write operations");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            we = 1; addr = 4'hA; din = 8'hA1;

            @(negedge clk);
            we = 1; addr = 4'hB; din = 8'hB2;

            @(negedge clk);
            we = 0; addr = 4'hA;

            @(negedge clk);
            addr = 4'hB;

            #1;


            check_outputs(8'hA1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_dout;
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
