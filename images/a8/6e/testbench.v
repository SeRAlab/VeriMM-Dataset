`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [27:0] addr;
    reg clk;
    reg [255:0] data;
    reg wen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data),
        .wen(wen)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wen = 0;
            addr = 0;
            data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Min Address (0)", test_num);
            reset_dut();
            addr = 28'h0000000;
            data = 256'hA5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A;
            wen = 1;
            @(posedge clk);
            #1;
            expected_data = data;
            check_addr = addr;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Max Address (2^28-1)", test_num);
            reset_dut();
            addr = 28'hFFFFFFF;
            data = 256'h12345678_9ABCDEF0_12345678_9ABCDEF0_12345678_9ABCDEF0_12345678_9ABCDEF0;
            wen = 1;
            @(posedge clk);
            #1;
            expected_data = data;
            check_addr = addr;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Mid-Range Address", test_num);
            reset_dut();
            addr = 28'h555AAAA;
            data = 256'hFFFFFFFF_00000000_FFFFFFFF_00000000_FFFFFFFF_00000000_FFFFFFFF_00000000;
            wen = 1;
            @(posedge clk);
            #1;
            expected_data = data;
            check_addr = addr;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Write Enable (wen=0)", test_num);
            reset_dut();

            addr = 28'h0ABCDEF;
            data = 256'hCAFECAFE_BABE1234_CAFECAFE_BABE1234_CAFECAFE_BABE1234_CAFECAFE_BABE1234;
            wen = 1;
            @(posedge clk);
            #1;

            data = 256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
            wen = 0;
            @(posedge clk);
            #1;

            expected_data = 256'hCAFECAFE_BABE1234_CAFECAFE_BABE1234_CAFECAFE_BABE1234_CAFECAFE_BABE1234;
            check_addr = addr;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Overwrite", test_num);
            reset_dut();
            addr = 28'h7777777;
            wen = 1;
            data = 256'h1111_2222_3333_4444_5555_6666_7777_8888_9999_0000_AAAA_BBBB_CCCC_DDDD_EEEE_FFFF;
            @(posedge clk);
            #1;
            data = 256'hDEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF;
            @(posedge clk);
            #1;
            expected_data = data;
            check_addr = addr;
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
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,addr, clk, data, wen);
    end

endmodule
