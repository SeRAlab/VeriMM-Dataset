`timescale 1ns/1ps

module mux_2to1_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in0;
    reg [7:0] in1;
    reg rst_n;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_8bit dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .rst_n(rst_n),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            in0 = 8'h0;
            in1 = 8'h0;
            sel = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Select in0 (8'hAA)");
            reset_dut();
            in0 = 8'hAA;
            in1 = 8'h55;
            sel = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select in1 (8'h55)");
            reset_dut();
            in0 = 8'hAA;
            in1 = 8'h55;
            sel = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select in0 with all bits high (8'hFF)");
            reset_dut();
            in0 = 8'hFF;
            in1 = 8'h00;
            sel = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select in1 with all bits low (8'h00)");
            reset_dut();
            in0 = 8'hFF;
            in1 = 8'h00;
            sel = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Random pattern on in0");
            reset_dut();
            in0 = 8'hA5;
            in1 = 8'h5A;
            sel = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify reset overrides inputs");
            reset_dut();
            in0 = 8'hFF;
            in1 = 8'hFF;
            sel = 1;
            rst_n = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Toggle select signal");
            reset_dut();
            in0 = 8'h12;
            in1 = 8'h34;
            sel = 0;
            @(posedge clk);
            #1;
            sel = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h34);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_out;
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
        $dumpvars(0,clk, in0, in1, rst_n, sel, out);
    end

endmodule
