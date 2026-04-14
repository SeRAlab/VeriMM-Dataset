`timescale 1ns/1ps

module generic_fifo_ctrl_tb;

    // Testbench signals (sequential circuit)
    reg rclk;
    reg ren;
    reg rrst_n;
    reg wclk;
    reg wen;
    reg wrst_n;
    wire [3:0] mem_raddr;
    wire mem_ren;
    wire [3:0] mem_waddr;
    wire mem_wen;
    wire ralmost_empty;
    wire rempty;
    wire walmost_full;
    wire wfull;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    generic_fifo_ctrl dut (
        .rclk(rclk),
        .ren(ren),
        .rrst_n(rrst_n),
        .wclk(wclk),
        .wen(wen),
        .wrst_n(wrst_n),
        .mem_raddr(mem_raddr),
        .mem_ren(mem_ren),
        .mem_waddr(mem_waddr),
        .mem_wen(mem_wen),
        .ralmost_empty(ralmost_empty),
        .rempty(rempty),
        .walmost_full(walmost_full),
        .wfull(wfull)
    );

    // Clock generation (10ns period)
    initial begin
        rclk = 0;
        forever #5 rclk = ~rclk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("generic_fifo_ctrl Testbench");
        $display("========================================");


        
        
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
        input [3:0] expected_mem_raddr;
        input expected_mem_ren;
        input [3:0] expected_mem_waddr;
        input expected_mem_wen;
        input expected_ralmost_empty;
        input expected_rempty;
        input expected_walmost_full;
        input expected_wfull;
        begin
            if (expected_mem_raddr === (expected_mem_raddr ^ mem_raddr ^ expected_mem_raddr) &&
                expected_mem_ren === (expected_mem_ren ^ mem_ren ^ expected_mem_ren) &&
                expected_mem_waddr === (expected_mem_waddr ^ mem_waddr ^ expected_mem_waddr) &&
                expected_mem_wen === (expected_mem_wen ^ mem_wen ^ expected_mem_wen) &&
                expected_ralmost_empty === (expected_ralmost_empty ^ ralmost_empty ^ expected_ralmost_empty) &&
                expected_rempty === (expected_rempty ^ rempty ^ expected_rempty) &&
                expected_walmost_full === (expected_walmost_full ^ walmost_full ^ expected_walmost_full) &&
                expected_wfull === (expected_wfull ^ wfull ^ expected_wfull)) begin
                $display("PASS");
                $display("  Outputs: mem_raddr=%h, mem_ren=%b, mem_waddr=%h, mem_wen=%b, ralmost_empty=%b, rempty=%b, walmost_full=%b, wfull=%b",
                         mem_raddr, mem_ren, mem_waddr, mem_wen, ralmost_empty, rempty, walmost_full, wfull);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_raddr=%h, mem_ren=%b, mem_waddr=%h, mem_wen=%b, ralmost_empty=%b, rempty=%b, walmost_full=%b, wfull=%b",
                         expected_mem_raddr, expected_mem_ren, expected_mem_waddr, expected_mem_wen, expected_ralmost_empty, expected_rempty, expected_walmost_full, expected_wfull);
                $display("  Got:      mem_raddr=%h, mem_ren=%b, mem_waddr=%h, mem_wen=%b, ralmost_empty=%b, rempty=%b, walmost_full=%b, wfull=%b",
                         mem_raddr, mem_ren, mem_waddr, mem_wen, ralmost_empty, rempty, walmost_full, wfull);
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
        $dumpvars(0,rclk, ren, rrst_n, wclk, wen, wrst_n, mem_raddr, mem_ren, mem_waddr, mem_wen, ralmost_empty, rempty, walmost_full, wfull);
    end

endmodule
