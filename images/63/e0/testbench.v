`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] dest;
    reg forward_enable;
    reg [4:0] mem_dest;
    reg mem_wb;
    reg [4:0] src1;
    reg [4:0] src2;
    reg [4:0] write_back_dest;
    reg write_back_wb;
    wire [1:0] to_src2_mux;
    wire [1:0] to_val1_mux;
    wire [1:0] to_val2_mux;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dest(dest),
        .forward_enable(forward_enable),
        .mem_dest(mem_dest),
        .mem_wb(mem_wb),
        .src1(src1),
        .src2(src2),
        .write_back_dest(write_back_dest),
        .write_back_wb(write_back_wb),
        .to_src2_mux(to_src2_mux),
        .to_val1_mux(to_val1_mux),
        .to_val2_mux(to_val2_mux)
    );
    task testcase001;

        begin
            $display("Testcase 001: Forwarding Disabled");
            forward_enable = 0;
            src1 = 5'd1;
            src2 = 5'd2;
            mem_dest = 5'd1;
            write_back_dest = 5'd2;
            mem_wb = 1;
            write_back_wb = 1;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Forward from MEM stage to SRC1");
            forward_enable = 1;
            src1 = 5'd10;
            src2 = 5'd11;
            mem_dest = 5'd10;
            write_back_dest = 5'd0;
            mem_wb = 1;
            write_back_wb = 0;
            #1;

            check_outputs(2'b00, 2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Forward from MEM stage to SRC2");
            forward_enable = 1;
            src1 = 5'd10;
            src2 = 5'd11;
            mem_dest = 5'd11;
            write_back_dest = 5'd0;
            mem_wb = 1;
            write_back_wb = 0;
            #1;

            check_outputs(2'b01, 2'b00, 2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Forward from WB stage to SRC1");
            forward_enable = 1;
            src1 = 5'd15;
            src2 = 5'd16;
            mem_dest = 5'd0;
            write_back_dest = 5'd15;
            mem_wb = 0;
            write_back_wb = 1;
            #1;

            check_outputs(2'b00, 2'b10, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Forward from WB stage to SRC2");
            forward_enable = 1;
            src1 = 5'd15;
            src2 = 5'd16;
            mem_dest = 5'd0;
            write_back_dest = 5'd16;
            mem_wb = 0;
            write_back_wb = 1;
            #1;

            check_outputs(2'b10, 2'b00, 2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Dual Forwarding (MEM to SRC1, WB to SRC2)");
            forward_enable = 1;
            src1 = 5'd5;
            src2 = 5'd6;
            mem_dest = 5'd5;
            write_back_dest = 5'd6;
            mem_wb = 1;
            write_back_wb = 1;
            #1;

            check_outputs(2'b10, 2'b01, 2'b10);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Priority Check (MEM priority over WB for same register)");
            forward_enable = 1;
            src1 = 5'd7;
            src2 = 5'd7;
            mem_dest = 5'd7;
            write_back_dest = 5'd7;
            mem_wb = 1;
            write_back_wb = 1;

            #1;


            check_outputs(2'b01, 2'b01, 2'b01);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Register 0 check (No forwarding to R0)");
            forward_enable = 1;
            src1 = 5'd0;
            src2 = 5'd0;
            mem_dest = 5'd0;
            write_back_dest = 5'd0;
            mem_wb = 1;
            write_back_wb = 1;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: WB signals active but no address match");
            forward_enable = 1;
            src1 = 5'd20;
            src2 = 5'd21;
            mem_dest = 5'd22;
            write_back_dest = 5'd23;
            mem_wb = 1;
            write_back_wb = 1;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Write back disabled signals");
            forward_enable = 1;
            src1 = 5'd1;
            src2 = 5'd1;
            mem_dest = 5'd1;
            write_back_dest = 5'd1;
            mem_wb = 0;
            write_back_wb = 0;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00);
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
        input [1:0] expected_to_src2_mux;
        input [1:0] expected_to_val1_mux;
        input [1:0] expected_to_val2_mux;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_to_src2_mux === (expected_to_src2_mux ^ to_src2_mux ^ expected_to_src2_mux) &&
                expected_to_val1_mux === (expected_to_val1_mux ^ to_val1_mux ^ expected_to_val1_mux) &&
                expected_to_val2_mux === (expected_to_val2_mux ^ to_val2_mux ^ expected_to_val2_mux)) begin
                $display("PASS");
                $display("  Outputs: to_src2_mux=%h, to_val1_mux=%h, to_val2_mux=%h",
                         to_src2_mux, to_val1_mux, to_val2_mux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: to_src2_mux=%h, to_val1_mux=%h, to_val2_mux=%h",
                         expected_to_src2_mux, expected_to_val1_mux, expected_to_val2_mux);
                $display("  Got:      to_src2_mux=%h, to_val1_mux=%h, to_val2_mux=%h",
                         to_src2_mux, to_val1_mux, to_val2_mux);
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

endmodule
