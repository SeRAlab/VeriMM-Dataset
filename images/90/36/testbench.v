`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [63:0] probe0;
    reg [63:0] probe1;
    reg [7:0] probe13;
    reg [63:0] probe14;
    reg [31:0] probe15;
    reg [7:0] probe2;
    reg [7:0] probe3;
    reg [7:0] probe4;
    reg [7:0] probe5;
    reg [7:0] probe6;
    reg [7:0] probe7;
    reg [63:0] probe8;
    reg [31:0] probe9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .probe0(probe0),
        .probe1(probe1),
        .probe13(probe13),
        .probe14(probe14),
        .probe15(probe15),
        .probe2(probe2),
        .probe3(probe3),
        .probe4(probe4),
        .probe5(probe5),
        .probe6(probe6),
        .probe7(probe7),
        .probe8(probe8),
        .probe9(probe9)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase 001: System Reset/Zeroing inputs");
            probe0 = 0; probe1 = 0; probe2 = 0; probe3 = 0;
            probe4 = 0; probe5 = 0; probe6 = 0; probe7 = 0;
            probe8 = 0; probe9 = 0; probe13 = 0; probe14 = 0; probe15 = 0;
            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase 002: Hex pattern injection");
            probe0  = 64'hDEADBEEFCAFEBABE;
            probe1  = 64'h0123456789ABCDEF;
            probe8  = 64'hAAAA_5555_AAAA_5555;
            probe14 = 64'hFFFF_0000_FFFF_0000;
            probe9  = 32'h8888_7777;
            probe15 = 32'h1111_2222;
            probe2  = 8'hAA; probe3  = 8'hBB; probe4  = 8'hCC;
            probe5  = 8'hDD; probe6  = 8'hEE; probe7  = 8'hFF;
            probe13 = 8'h13;
            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase 003: Testing 8-bit probes with sequential values");
            probe2 = 8'd10; probe3 = 8'd20; probe4 = 8'd30;
            probe5 = 8'd40; probe6 = 8'd50; probe7 = 8'd60;
            probe13 = 8'd70;
            @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase 004: Maximum values (all ones)");
            probe0 = -1; probe1 = -1; probe8 = -1; probe14 = -1;
            probe9 = -1; probe15 = -1;
            probe2 = 8'hFF; probe3 = 8'hFF; probe4 = 8'hFF;
            probe5 = 8'hFF; probe6 = 8'hFF; probe7 = 8'hFF;
            probe13 = 8'hFF;
            @(posedge clk);
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
