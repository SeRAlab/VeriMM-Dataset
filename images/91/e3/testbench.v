`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] master_rdat;
    reg master_rstb;
    reg master_trdy;
    reg rst;
    reg [7:0] slave_addr;
    reg [15:0] slave_wdat;
    reg slave_wstb;
    wire [7:0] master_addr;
    wire [3:0] master_port;
    wire master_tstb;
    wire [3:0] master_type;
    wire [15:0] master_wdat;
    wire [15:0] slave_rdat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .master_rdat(master_rdat),
        .master_rstb(master_rstb),
        .master_trdy(master_trdy),
        .rst(rst),
        .slave_addr(slave_addr),
        .slave_wdat(slave_wdat),
        .slave_wstb(slave_wstb),
        .master_addr(master_addr),
        .master_port(master_port),
        .master_tstb(master_tstb),
        .master_type(master_type),
        .master_wdat(master_wdat),
        .slave_rdat(slave_rdat)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Reset State", test_num);
            rst = 1;
            slave_addr = 8'hFF; slave_wdat = 16'hFFFF; slave_wstb = 1;
            master_rdat = 16'hFFFF; master_rstb = 1; master_trdy = 1;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h0, 4'h0, 1'b0, 4'h0, 16'h0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Write Transaction", test_num);
            rst = 1; #10; rst = 0;
            @(posedge clk);
            slave_addr = 8'h1A;
            slave_wdat = 16'hDEAD;
            slave_wstb = 1'b1;
            @(posedge clk);

            #1;


            check_outputs(8'h1A, 4'h0, 1'b1, 4'h0, 16'hDEAD, 16'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Read Transaction", test_num);
            rst = 1; #10; rst = 0;
            @(posedge clk);
            slave_addr = 8'h2B;
            slave_wstb = 1'b0;
            master_rdat = 16'hBEEF;
            master_rstb = 1'b1;
            @(posedge clk);

            #1;


            check_outputs(8'h2B, 4'h0, 1'b0, 4'h0, 16'h0, 16'hBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: High Data Integrity", test_num);
            rst = 1; #10; rst = 0;
            @(posedge clk);
            slave_addr = 8'hFF;
            slave_wdat = 16'hAAAA;
            slave_wstb = 1'b1;
            master_rdat = 16'h5555;
            @(posedge clk);
            #1;

            check_outputs(8'hFF, 4'h0, 1'b1, 4'h0, 16'hAAAA, 16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Transaction Ready Check", test_num);
            rst = 1; #10; rst = 0;
            @(posedge clk);
            slave_addr = 8'h40;
            slave_wstb = 1'b1;
            master_trdy = 1'b1;
            @(posedge clk);
            #1;

            check_outputs(8'h40, 4'h0, 1'b1, 4'h0, 16'h0, 16'h0);
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
        input [7:0] expected_master_addr;
        input [3:0] expected_master_port;
        input expected_master_tstb;
        input [3:0] expected_master_type;
        input [15:0] expected_master_wdat;
        input [15:0] expected_slave_rdat;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_master_addr === (expected_master_addr ^ master_addr ^ expected_master_addr) &&
                expected_master_port === (expected_master_port ^ master_port ^ expected_master_port) &&
                expected_master_tstb === (expected_master_tstb ^ master_tstb ^ expected_master_tstb) &&
                expected_master_type === (expected_master_type ^ master_type ^ expected_master_type) &&
                expected_master_wdat === (expected_master_wdat ^ master_wdat ^ expected_master_wdat) &&
                expected_slave_rdat === (expected_slave_rdat ^ slave_rdat ^ expected_slave_rdat)) begin
                $display("PASS");
                $display("  Outputs: master_addr=%h, master_port=%h, master_tstb=%b, master_type=%h, master_wdat=%h, slave_rdat=%h",
                         master_addr, master_port, master_tstb, master_type, master_wdat, slave_rdat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: master_addr=%h, master_port=%h, master_tstb=%b, master_type=%h, master_wdat=%h, slave_rdat=%h",
                         expected_master_addr, expected_master_port, expected_master_tstb, expected_master_type, expected_master_wdat, expected_slave_rdat);
                $display("  Got:      master_addr=%h, master_port=%h, master_tstb=%b, master_type=%h, master_wdat=%h, slave_rdat=%h",
                         master_addr, master_port, master_tstb, master_type, master_wdat, slave_rdat);
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
