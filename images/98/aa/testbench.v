`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [4:0] Rd_addr;
    reg [7:0] Rd_in;
    reg Rd_write_byte_en;
    reg [4:0] Rs_addr;
    reg [4:0] Rt_addr;
    wire [7:0] Rs_out;
    wire [7:0] Rt_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Rd_addr(Rd_addr),
        .Rd_in(Rd_in),
        .Rd_write_byte_en(Rd_write_byte_en),
        .Rs_addr(Rs_addr),
        .Rt_addr(Rt_addr),
        .Rs_out(Rs_out),
        .Rt_out(Rt_out)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Rd_addr = 5'b0;
            Rd_in = 8'b0;
            Rd_write_byte_en = 1'b0;
            Rs_addr = 5'b0;
            Rt_addr = 5'b0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Basic Write to R1 and Read back");

            Rd_addr = 5'd1;
            Rd_in = 8'hA5;
            Rd_write_byte_en = 1'b1;

            @(negedge Clk);
            #2;
            Rd_write_byte_en = 1'b0;
            Rs_addr = 5'd1;
            Rt_addr = 5'd0;
            #2;

            #1;


            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Attempt Write to Register 0");

            Rd_addr = 5'd0;
            Rd_in = 8'hFF;
            Rd_write_byte_en = 1'b1;

            @(negedge Clk);
            #2;
            Rd_write_byte_en = 1'b0;
            Rs_addr = 5'd0;
            Rt_addr = 5'd0;
            #2;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Write Enable Check (Disable Write)");


            Rs_addr = 5'd2;
            #1;

            Rd_addr = 5'd2;
            Rd_in = 8'h55;
            Rd_write_byte_en = 1'b0;

            @(negedge Clk);
            #2;
            Rs_addr = 5'd2;
            Rt_addr = 5'd0;
            #2;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Simultaneous Reads from Rs and Rt");


            Rd_addr = 5'd10;
            Rd_in = 8'h11;
            Rd_write_byte_en = 1'b1;
            @(negedge Clk);
            #2;


            Rd_addr = 5'd20;
            Rd_in = 8'h22;
            Rd_write_byte_en = 1'b1;
            @(negedge Clk);
            #2;

            Rd_write_byte_en = 1'b0;
            Rs_addr = 5'd10;
            Rt_addr = 5'd20;
            #2;

            #1;


            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Boundary (R31) and Overwrite");


            Rd_addr = 5'd31;
            Rd_in = 8'hAA;
            Rd_write_byte_en = 1'b1;
            @(negedge Clk);
            #2;


            Rd_addr = 5'd31;
            Rd_in = 8'hBB;
            Rd_write_byte_en = 1'b1;
            @(negedge Clk);
            #2;

            Rd_write_byte_en = 1'b0;
            Rs_addr = 5'd31;
            Rt_addr = 5'd31;
            #2;

            #1;


            check_outputs(8'hBB, 8'hBB);
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
        input [7:0] expected_Rs_out;
        input [7:0] expected_Rt_out;
        begin
            if (expected_Rs_out === (expected_Rs_out ^ Rs_out ^ expected_Rs_out) &&
                expected_Rt_out === (expected_Rt_out ^ Rt_out ^ expected_Rt_out)) begin
                $display("PASS");
                $display("  Outputs: Rs_out=%h, Rt_out=%h",
                         Rs_out, Rt_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rs_out=%h, Rt_out=%h",
                         expected_Rs_out, expected_Rt_out);
                $display("  Got:      Rs_out=%h, Rt_out=%h",
                         Rs_out, Rt_out);
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
        $dumpvars(0,Clk, Rd_addr, Rd_in, Rd_write_byte_en, Rs_addr, Rt_addr, Rs_out, Rt_out);
    end

endmodule
