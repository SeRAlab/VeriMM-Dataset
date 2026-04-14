`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [63:0] probe0;
    reg [63:0] probe1;
    reg [31:0] probe2;
    reg [31:0] probe3;
    reg probe4;
    reg probe5;
    reg probe6;
    reg probe7;
    wire [127:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .probe0(probe0),
        .probe1(probe1),
        .probe2(probe2),
        .probe3(probe3),
        .probe4(probe4),
        .probe5(probe5),
        .probe6(probe6),
        .probe7(probe7),
        .output_signal(output_signal)
    );
    task reset_signals;

        begin
            probe0 = 64'd0;
            probe1 = 64'd0;
            probe2 = 32'd0;
            probe3 = 32'd0;
            probe4 = 1'b0;
            probe5 = 1'b0;
            probe6 = 1'b0;
            probe7 = 1'b1;
            #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_signals();
            probe0 = 64'h0;
            probe1 = 64'h0;
            probe2 = 32'h0;
            probe3 = 32'h0;
            probe4 = 1'b0; probe5 = 1'b0; probe6 = 1'b0; probe7 = 1'b0;


            #1;



            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones", test_num);
            reset_signals();
            probe0 = {64{1'b1}};
            probe1 = {64{1'b1}};
            probe2 = {32{1'b1}};
            probe3 = {32{1'b1}};
            probe4 = 1'b1; probe5 = 1'b1; probe6 = 1'b1; probe7 = 1'b1;

            #1;


            check_outputs({128{1'b1}});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Alternating Patterns", test_num);
            reset_signals();
            probe0 = 64'h5555_5555_5555_5555;
            probe1 = 64'hAAAA_AAAA_AAAA_AAAA;
            probe2 = 32'h5555_5555;
            probe3 = 32'hAAAA_AAAA;
            probe4 = 1'b0; probe5 = 1'b1; probe6 = 1'b0; probe7 = 1'b1;


            #1;



            check_outputs({64'hAAAA_AAAA_AAAA_AAAA, 64'h5555_5555_5555_5555});
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Unique Nibbles", test_num);
            reset_signals();
            probe0 = 64'hFEDCBA9876543210;
            probe1 = 64'h0123456789ABCDEF;
            probe2 = 32'hAABBCCDD;
            probe3 = 32'h11223344;
            probe4 = 1'b1; probe5 = 1'b0; probe6 = 1'b1; probe7 = 1'b0;

            #1;


            check_outputs({64'h0123456789ABCDEF, 64'hFEDCBA9876543210});
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary Bits", test_num);
            reset_signals();
            probe0 = 64'h0000_0000_0000_0001;
            probe1 = 64'h8000_0000_0000_0000;
            probe2 = 32'hFFFF_FFFF;
            probe3 = 32'h0000_0000;
            probe4 = 1'b1; probe5 = 1'b1; probe6 = 1'b1; probe7 = 1'b1;

            #1;


            check_outputs({64'h8000_0000_0000_0000, 64'h0000_0000_0000_0001});
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
        input [127:0] expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
