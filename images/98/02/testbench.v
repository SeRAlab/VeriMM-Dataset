`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pcx_atom_px;
    reg pcx_grant_px;
    reg pcx_req_pa;
    reg pcx_req_px;
    reg rclk;
    reg reset_l;
    wire request_mask_pa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pcx_atom_px(pcx_atom_px),
        .pcx_grant_px(pcx_grant_px),
        .pcx_req_pa(pcx_req_pa),
        .pcx_req_px(pcx_req_px),
        .rclk(rclk),
        .reset_l(reset_l),
        .request_mask_pa(request_mask_pa)
    );

    // Clock generation (10ns period)
    initial begin
        rclk = 0;
        forever #5 rclk = ~rclk;
    end

        task reset_dut;

        begin
            reset_l = 0;
            pcx_atom_px = 0;
            pcx_grant_px = 0;
            pcx_req_pa = 0;
            pcx_req_px = 0;
            repeat (2) @(posedge rclk);
            #1 reset_l = 1;
            @(posedge rclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Request sets the mask", test_num);
            reset_dut();
            pcx_req_px = 1;
            @(posedge rclk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Grant clears the mask", test_num);
            reset_dut();

            pcx_req_px = 1;
            @(posedge rclk);
            #1;

            pcx_req_px = 0;
            pcx_grant_px = 1;
            @(posedge rclk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Atomic operation sets the mask", test_num);
            reset_dut();
            pcx_atom_px = 1;
            @(posedge rclk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Grant priority over Request", test_num);
            reset_dut();

            pcx_req_px = 1;
            pcx_grant_px = 1;
            @(posedge rclk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mask persistence without grant", test_num);
            reset_dut();
            pcx_req_px = 1;
            @(posedge rclk);
            #1;
            pcx_req_px = 0;
            repeat (2) @(posedge rclk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_request_mask_pa;
        begin
            if (expected_request_mask_pa === (expected_request_mask_pa ^ request_mask_pa ^ expected_request_mask_pa)) begin
                $display("PASS");
                $display("  Outputs: request_mask_pa=%b",
                         request_mask_pa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: request_mask_pa=%b",
                         expected_request_mask_pa);
                $display("  Got:      request_mask_pa=%b",
                         request_mask_pa);
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
        $dumpvars(0,pcx_atom_px, pcx_grant_px, pcx_req_pa, pcx_req_px, rclk, reset_l, request_mask_pa);
    end

endmodule
