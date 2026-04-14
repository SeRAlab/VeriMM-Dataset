`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i;
    wire [7:0] m_eth_payload_axis_tkeep;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i(i),
        .m_eth_payload_axis_tkeep(m_eth_payload_axis_tkeep)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            i = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: i=1 stimulus", test_num);
            reset_dut();
            i = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: i=0 stimulus", test_num);
            reset_dut();
            i = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition i: 1 -> 0", test_num);
            reset_dut();
            i = 1;
            @(posedge clk);
            #1;
            i = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition i: 0 -> 1", test_num);
            reset_dut();
            i = 0;
            @(posedge clk);
            #1;
            i = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Persistent i=1", test_num);
            reset_dut();
            i = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Persistent i=0", test_num);
            reset_dut();
            i = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggling stimulus", test_num);
            reset_dut();
            i = 1; @(posedge clk);
            i = 0; @(posedge clk);
            i = 1; @(posedge clk);
            i = 0; @(posedge clk);
            i = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_m_eth_payload_axis_tkeep;
        begin
            if (expected_m_eth_payload_axis_tkeep === (expected_m_eth_payload_axis_tkeep ^ m_eth_payload_axis_tkeep ^ expected_m_eth_payload_axis_tkeep)) begin
                $display("PASS");
                $display("  Outputs: m_eth_payload_axis_tkeep=%h",
                         m_eth_payload_axis_tkeep);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_eth_payload_axis_tkeep=%h",
                         expected_m_eth_payload_axis_tkeep);
                $display("  Got:      m_eth_payload_axis_tkeep=%h",
                         m_eth_payload_axis_tkeep);
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
        $dumpvars(0,clk, i, m_eth_payload_axis_tkeep);
    end

endmodule
