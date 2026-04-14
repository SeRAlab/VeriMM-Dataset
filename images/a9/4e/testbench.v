`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] rd_i;
    reg [4:0] rs1_i;
    reg [4:0] rs2_i;
    reg [31:0] w_data;
    reg w_en;
    wire [31:0] rs1_o;
    wire [31:0] rs2_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_i(rd_i),
        .rs1_i(rs1_i),
        .rs2_i(rs2_i),
        .w_data(w_data),
        .w_en(w_en),
        .rs1_o(rs1_o),
        .rs2_o(rs2_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rd_i = 0;
            rs1_i = 0;
            rs2_i = 0;
            w_data = 0;
            w_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Simple Write/Read...");
            reset_dut();


            rd_i = 5'd1;
            w_data = 32'hABCDE001;
            w_en = 1;
            @(posedge clk);
            #1;


            w_en = 0;
            rs1_i = 5'd1;
            rs2_i = 5'd1;
            #2;

            #1;


            check_outputs(32'hABCDE001, 32'hABCDE001);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Hardwired Zero Check...");
            reset_dut();


            rd_i = 5'd0;
            w_data = 32'hFFFFFFFF;
            w_en = 1;
            @(posedge clk);
            #1;


            w_en = 0;
            rs1_i = 5'd0;
            rs2_i = 5'd0;
            #2;

            #1;


            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Simultaneous Dual Read...");
            reset_dut();


            rd_i = 5'd10;
            w_data = 32'h10101010;
            w_en = 1;
            @(posedge clk);
            #1;


            rd_i = 5'd20;
            w_data = 32'h20202020;
            w_en = 1;
            @(posedge clk);
            #1;


            w_en = 0;
            rs1_i = 5'd10;
            rs2_i = 5'd20;
            #2;

            #1;


            check_outputs(32'h10101010, 32'h20202020);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Enable Check...");
            reset_dut();


            rd_i = 5'd15;
            w_data = 32'h55555555;
            w_en = 1;
            @(posedge clk);
            #1;


            rd_i = 5'd15;
            w_data = 32'hAAAAAAAA;
            w_en = 0;
            @(posedge clk);
            #1;


            rs1_i = 5'd15;
            rs2_i = 0;
            #2;


            #1;



            check_outputs(32'h55555555, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary Register 31...");
            reset_dut();


            rd_i = 5'd31;
            w_data = 32'h7FFFFFFF;
            w_en = 1;
            @(posedge clk);
            #1;


            w_en = 0;
            rs1_i = 5'd31;
            rs2_i = 5'd0;
            #2;

            #1;


            check_outputs(32'h7FFFFFFF, 32'h00000000);
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
        input [31:0] expected_rs1_o;
        input [31:0] expected_rs2_o;
        begin
            if (expected_rs1_o === (expected_rs1_o ^ rs1_o ^ expected_rs1_o) &&
                expected_rs2_o === (expected_rs2_o ^ rs2_o ^ expected_rs2_o)) begin
                $display("PASS");
                $display("  Outputs: rs1_o=%h, rs2_o=%h",
                         rs1_o, rs2_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rs1_o=%h, rs2_o=%h",
                         expected_rs1_o, expected_rs2_o);
                $display("  Got:      rs1_o=%h, rs2_o=%h",
                         rs1_o, rs2_o);
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
        $dumpvars(0,clk, rd_i, rs1_i, rs2_i, w_data, w_en, rs1_o, rs2_o);
    end

endmodule
