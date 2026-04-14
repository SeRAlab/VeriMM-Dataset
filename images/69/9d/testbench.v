`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg m_axi_ready;
    reg resetn;
    reg [31:0] s_axi_data;
    reg s_axi_valid;
    wire [31:0] m_axi_data;
    wire m_axi_valid;
    wire s_axi_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m_axi_ready(m_axi_ready),
        .resetn(resetn),
        .s_axi_data(s_axi_data),
        .s_axi_valid(s_axi_valid),
        .m_axi_data(m_axi_data),
        .m_axi_valid(m_axi_valid),
        .s_axi_ready(s_axi_ready)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset Behavior", test_num);
            resetn = 0;
            s_axi_valid = 0;
            s_axi_data = 32'h0;
            m_axi_ready = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Single Transaction", test_num);
            resetn = 0; #10; resetn = 1; @(posedge clk);

            s_axi_data = 32'hAAAA_BBBB;
            s_axi_valid = 1;
            m_axi_ready = 1;

            @(posedge clk);
            s_axi_valid = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Back-to-Back Streaming", test_num);
            resetn = 0; #10; resetn = 1; @(posedge clk);

            m_axi_ready = 1;
            s_axi_valid = 1;
            s_axi_data = 32'h1111_1111;
            @(posedge clk);
            s_axi_data = 32'h2222_2222;
            @(posedge clk);
            s_axi_data = 32'h3333_3333;
            @(posedge clk);
            s_axi_valid = 0;

            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h3333_3333, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Master Stall (Backpressure)", test_num);
            resetn = 0; #10; resetn = 1; @(posedge clk);


            m_axi_ready = 0;
            s_axi_valid = 1;
            s_axi_data = 32'hCAFE_BABE;
            @(posedge clk);
            s_axi_valid = 0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'hCAFE_BABE, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Skid Buffer Full", test_num);
            resetn = 0; #10; resetn = 1; @(posedge clk);

            m_axi_ready = 0;


            s_axi_valid = 1;
            s_axi_data = 32'hD001_D001;
            @(posedge clk);


            s_axi_data = 32'hD002_D002;
            @(posedge clk);


            s_axi_valid = 1;
            s_axi_data = 32'hD003_D003;
            #1;

            #1;


            check_outputs(32'hD001_D001, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Clearing Skid Buffer", test_num);


            m_axi_ready = 1;
            s_axi_valid = 0;

            @(posedge clk);
            @(posedge clk);

            #1;

            #1;


            check_outputs(m_axi_data, 1'b0, 1'b1);
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
        input [31:0] expected_m_axi_data;
        input expected_m_axi_valid;
        input expected_s_axi_ready;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m_axi_data === (expected_m_axi_data ^ m_axi_data ^ expected_m_axi_data) &&
                expected_m_axi_valid === (expected_m_axi_valid ^ m_axi_valid ^ expected_m_axi_valid) &&
                expected_s_axi_ready === (expected_s_axi_ready ^ s_axi_ready ^ expected_s_axi_ready)) begin
                $display("PASS");
                $display("  Outputs: m_axi_data=%h, m_axi_valid=%b, s_axi_ready=%b",
                         m_axi_data, m_axi_valid, s_axi_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_axi_data=%h, m_axi_valid=%b, s_axi_ready=%b",
                         expected_m_axi_data, expected_m_axi_valid, expected_s_axi_ready);
                $display("  Got:      m_axi_data=%h, m_axi_valid=%b, s_axi_ready=%b",
                         m_axi_data, m_axi_valid, s_axi_ready);
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
