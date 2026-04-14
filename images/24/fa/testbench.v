`timescale 1ns/1ps

module VirtualMemoryManager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] pframe_in;
    reg rst;
    reg [1:0] vpage;
    reg write_enable;
    wire [1:0] pframe_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManager dut (
        .clk(clk),
        .pframe_in(pframe_in),
        .rst(rst),
        .vpage(vpage),
        .write_enable(write_enable),
        .pframe_out(pframe_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            write_enable = 0;
            vpage = 0;
            pframe_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Post-Reset Verification", test_num);
            reset_dut();


            vpage = 2'b10;
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Write and Read (VPage 1)", test_num);
            reset_dut();

            @(negedge clk);
            write_enable = 1;
            vpage = 2'b01;
            pframe_in = 2'b11;
            @(posedge clk);

            #1 write_enable = 0;
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Write Enable Low Protection", test_num);
            reset_dut();

            @(negedge clk);
            write_enable = 0;
            vpage = 2'b11;
            pframe_in = 2'b10;
            @(posedge clk);

            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overwrite Existing Entry", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            vpage = 2'b00;
            pframe_in = 2'b01;
            @(posedge clk);


            @(negedge clk);
            pframe_in = 2'b10;
            @(posedge clk);

            #1 write_enable = 0;
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Multi-entry Data Integrity", test_num);
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            vpage = 2'b00;
            pframe_in = 2'b11;
            @(posedge clk);


            @(negedge clk);
            vpage = 2'b11;
            pframe_in = 2'b01;
            @(posedge clk);

            #1 write_enable = 0;
            vpage = 2'b00;
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryManager Testbench");
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
        input [1:0] expected_pframe_out;
        begin
            if (expected_pframe_out === (expected_pframe_out ^ pframe_out ^ expected_pframe_out)) begin
                $display("PASS");
                $display("  Outputs: pframe_out=%h",
                         pframe_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pframe_out=%h",
                         expected_pframe_out);
                $display("  Got:      pframe_out=%h",
                         pframe_out);
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
        $dumpvars(0,clk, pframe_in, rst, vpage, write_enable, pframe_out);
    end

endmodule
