`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg CARRYIN;
    reg CLK;
    reg RST;
    wire [31:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CARRYIN(CARRYIN),
        .CLK(CLK),
        .RST(RST),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            A = 0;
            B = 0;
            CARRYIN = 0;
            @(posedge CLK);
            #1 RST = 0;

            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 2 * 3 + 0", test_num);
            reset_dut();
            A = 16'd2;
            B = 16'd3;
            CARRYIN = 0;
            @(posedge CLK);
            #1 #1;
 check_outputs(32'h00000006);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 10 * 20 + 1", test_num);
            reset_dut();
            A = 16'd10;
            B = 16'd20;
            CARRYIN = 1;
            @(posedge CLK);
            #1 #1;
 check_outputs(32'h000000C9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 * 500 + 1", test_num);
            reset_dut();
            A = 16'd0;
            B = 16'd500;
            CARRYIN = 1;
            @(posedge CLK);
            #1 #1;
 check_outputs(32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0xFFFF * 1 + 0", test_num);
            reset_dut();
            A = 16'hFFFF;
            B = 16'h0001;
            CARRYIN = 0;
            @(posedge CLK);
            #1 #1;
 check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0xFFFF * 0xFFFF + 1", test_num);
            reset_dut();
            A = 16'hFFFF;
            B = 16'hFFFF;
            CARRYIN = 1;
            @(posedge CLK);
            #1 #1;
 check_outputs(32'hFFFE0002);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0x1234 * 0x5678 + 0", test_num);
            reset_dut();
            A = 16'h1234;
            B = 16'h5678;
            CARRYIN = 0;
            @(posedge CLK);
            #1 #1;
 check_outputs(32'h06260060);
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
        input [31:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, CARRYIN, CLK, RST, P);
    end

endmodule
