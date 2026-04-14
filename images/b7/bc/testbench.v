`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] r_ex;
    reg [31:0] r_mem;
    reg [31:0] r_rf;
    reg [31:0] r_wb;
    reg [4:0] ra_ex;
    reg [4:0] ra_mem;
    reg [4:0] ra_rf;
    reg [4:0] ra_wb;
    wire [31:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .r_ex(r_ex),
        .r_mem(r_mem),
        .r_rf(r_rf),
        .r_wb(r_wb),
        .ra_ex(ra_ex),
        .ra_mem(ra_mem),
        .ra_rf(ra_rf),
        .ra_wb(ra_wb),
        .r(r)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Hazards", test_num);
            ra_rf = 5'd1;
            ra_ex = 5'd2;
            ra_mem = 5'd3;
            ra_wb = 5'd4;
            r_rf = 32'hAAAA_AAAA;
            r_ex = 32'hBBBB_BBBB;
            r_mem = 32'hCCCC_CCCC;
            r_wb = 32'hDDDD_DDDD;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EX Hazard", test_num);
            ra_rf = 5'd10;
            ra_ex = 5'd10;
            ra_mem = 5'd11;
            ra_wb = 5'd12;
            r_rf = 32'h1111_1111;
            r_ex = 32'h2222_2222;
            r_mem = 32'h3333_3333;
            r_wb = 32'h4444_4444;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MEM Hazard", test_num);
            ra_rf = 5'd15;
            ra_ex = 5'd16;
            ra_mem = 5'd15;
            ra_wb = 5'd17;
            r_rf = 32'h5555_5555;
            r_ex = 32'h6666_6666;
            r_mem = 32'h7777_7777;
            r_wb = 32'h8888_8888;
            #1;

            check_outputs(32'h7777_7777);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: WB Hazard", test_num);
            ra_rf = 5'd20;
            ra_ex = 5'd21;
            ra_mem = 5'd22;
            ra_wb = 5'd20;
            r_rf = 32'h9999_9999;
            r_ex = 32'hAAAA_AAAA;
            r_mem = 32'hBBBB_BBBB;
            r_wb = 32'hCCCC_CCCC;
            #1;

            check_outputs(32'hCCCC_CCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority EX over MEM", test_num);
            ra_rf = 5'd5;
            ra_ex = 5'd5;
            ra_mem = 5'd5;
            ra_wb = 5'd30;
            r_rf = 32'h0000_0001;
            r_ex = 32'h0000_0002;
            r_mem = 32'h0000_0003;
            r_wb = 32'h0000_0004;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority MEM over WB", test_num);
            ra_rf = 5'd7;
            ra_ex = 5'd31;
            ra_mem = 5'd7;
            ra_wb = 5'd7;
            r_rf = 32'hF0F0_F0F0;
            r_ex = 32'hE0E0_E0E0;
            r_mem = 32'hD0D0_D0D0;
            r_wb = 32'hC0C0_C0C0;
            #1;

            check_outputs(32'hD0D0_D0D0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority EX over WB", test_num);
            ra_rf = 5'd3;
            ra_ex = 5'd3;
            ra_mem = 5'd8;
            ra_wb = 5'd3;
            r_rf = 32'h1234_5678;
            r_ex = 32'h8765_4321;
            r_mem = 32'hAAAA_BBBB;
            r_wb = 32'hCCCC_DDDD;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All stages match source", test_num);
            ra_rf = 5'd12;
            ra_ex = 5'd12;
            ra_mem = 5'd12;
            ra_wb = 5'd12;
            r_rf = 32'h1;
            r_ex = 32'h2;
            r_mem = 32'h3;
            r_wb = 32'h4;
            #1;

            check_outputs(32'h2);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Register 0 Forwarding Check", test_num);
            ra_rf = 5'd0;
            ra_ex = 5'd0;
            ra_mem = 5'd1;
            ra_wb = 5'd2;
            r_rf = 32'h0000_0000;
            r_ex = 32'hDEAD_BEEF;
            r_mem = 32'h0;
            r_wb = 32'h0;

            #1;


            check_outputs(32'hDEAD_BEEF);
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
        input [31:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
