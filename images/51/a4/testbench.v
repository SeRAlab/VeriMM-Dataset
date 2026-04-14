`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] r_reg_p1_rf_i;
    reg [4:0] r_reg_p2_rf_i;
    reg reset;
    reg [31:0] w_data_rf_i;
    reg w_en_rf_i;
    reg [4:0] w_reg_rf_i;
    wire [31:0] r_data_p1_rf_o;
    wire [31:0] r_data_p2_rf_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r_reg_p1_rf_i(r_reg_p1_rf_i),
        .r_reg_p2_rf_i(r_reg_p2_rf_i),
        .reset(reset),
        .w_data_rf_i(w_data_rf_i),
        .w_en_rf_i(w_en_rf_i),
        .w_reg_rf_i(w_reg_rf_i),
        .r_data_p1_rf_o(r_data_p1_rf_o),
        .r_data_p2_rf_o(r_data_p2_rf_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        w_en_rf_i = 0;
        w_data_rf_i = 0;
        w_reg_rf_i = 0;
        r_reg_p1_rf_i = 0;
        r_reg_p2_rf_i = 0;
        #10;
        @(negedge clk);
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Basic Write/Read Port 1");
        reset_dut();
        test_num = test_num + 1;


        @(posedge clk);
        w_en_rf_i = 1;
        w_reg_rf_i = 5'd1;
        w_data_rf_i = 32'h12345678;
        @(negedge clk);


        w_en_rf_i = 0;
        r_reg_p1_rf_i = 5'd1;
        r_reg_p2_rf_i = 5'd0;

        #5;
        #1;

        check_outputs(32'h12345678, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Basic Write/Read Port 2");
        reset_dut();
        test_num = test_num + 1;


        @(posedge clk);
        w_en_rf_i = 1;
        w_reg_rf_i = 5'd31;
        w_data_rf_i = 32'hDEADBEEF;
        @(negedge clk);


        w_en_rf_i = 0;
        r_reg_p1_rf_i = 5'd0;
        r_reg_p2_rf_i = 5'd31;

        #5;
        #1;

        check_outputs(32'h00000000, 32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Dual Port Read");
        reset_dut();
        test_num = test_num + 1;


        @(posedge clk);
        w_en_rf_i = 1;
        w_reg_rf_i = 5'd10;
        w_data_rf_i = 32'hAAAA5555;
        @(negedge clk);


        @(posedge clk);
        w_en_rf_i = 1;
        w_reg_rf_i = 5'd20;
        w_data_rf_i = 32'h5555AAAA;
        @(negedge clk);


        w_en_rf_i = 0;
        r_reg_p1_rf_i = 5'd10;
        r_reg_p2_rf_i = 5'd20;

        #5;
        #1;

        check_outputs(32'hAAAA5555, 32'h5555AAAA);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Write Enable Verification");
        reset_dut();
        test_num = test_num + 1;


        @(posedge clk);
        w_en_rf_i = 1;
        w_reg_rf_i = 5'd15;
        w_data_rf_i = 32'h00000001;
        @(negedge clk);


        @(posedge clk);
        w_en_rf_i = 0;
        w_reg_rf_i = 5'd15;
        w_data_rf_i = 32'h00000002;
        @(negedge clk);


        r_reg_p1_rf_i = 5'd15;
        r_reg_p2_rf_i = 5'd15;

        #5;
        #1;

        check_outputs(32'h00000001, 32'h00000001);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Reset Initialization Check");
        reset_dut();
        test_num = test_num + 1;


        @(posedge clk);
        w_en_rf_i = 1;
        w_reg_rf_i = 5'd7;
        w_data_rf_i = 32'hFFFFFFFF;
        @(negedge clk);


        reset = 1;
        #20;
        reset = 0;
        @(posedge clk);


        r_reg_p1_rf_i = 5'd7;
        r_reg_p2_rf_i = 5'd7;

        #5;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Overwrite Verification");
        reset_dut();
        test_num = test_num + 1;


        @(posedge clk);
        w_en_rf_i = 1;
        w_reg_rf_i = 5'd2;
        w_data_rf_i = 32'h11111111;
        @(negedge clk);


        @(posedge clk);
        w_en_rf_i = 1;
        w_reg_rf_i = 5'd2;
        w_data_rf_i = 32'h22222222;
        @(negedge clk);

        r_reg_p1_rf_i = 5'd2;
        r_reg_p2_rf_i = 5'd2;

        #5;
        #1;

        check_outputs(32'h22222222, 32'h22222222);
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
        input [31:0] expected_r_data_p1_rf_o;
        input [31:0] expected_r_data_p2_rf_o;
        begin
            if (expected_r_data_p1_rf_o === (expected_r_data_p1_rf_o ^ r_data_p1_rf_o ^ expected_r_data_p1_rf_o) &&
                expected_r_data_p2_rf_o === (expected_r_data_p2_rf_o ^ r_data_p2_rf_o ^ expected_r_data_p2_rf_o)) begin
                $display("PASS");
                $display("  Outputs: r_data_p1_rf_o=%h, r_data_p2_rf_o=%h",
                         r_data_p1_rf_o, r_data_p2_rf_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_data_p1_rf_o=%h, r_data_p2_rf_o=%h",
                         expected_r_data_p1_rf_o, expected_r_data_p2_rf_o);
                $display("  Got:      r_data_p1_rf_o=%h, r_data_p2_rf_o=%h",
                         r_data_p1_rf_o, r_data_p2_rf_o);
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
        $dumpvars(0,clk, r_reg_p1_rf_i, r_reg_p2_rf_i, reset, w_data_rf_i, w_en_rf_i, w_reg_rf_i, r_data_p1_rf_o, r_data_p2_rf_o);
    end

endmodule
