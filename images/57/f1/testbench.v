`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg read;
    reg reset;
    reg write;
    wire empty;
    wire full;
    wire [5:0] ram_raddr;
    wire [5:0] ram_raddr_next;
    wire [5:0] ram_waddr;
    wire ram_wen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .read(read),
        .reset(reset),
        .write(write),
        .empty(empty),
        .full(full),
        .ram_raddr(ram_raddr),
        .ram_raddr_next(ram_raddr_next),
        .ram_waddr(ram_waddr),
        .ram_wen(ram_wen)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        write = 0;
        read = 0;
        @(posedge clock);
        #1;
        reset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset State Check");
        reset_dut();


        #1;



        check_outputs(1'b1, 1'b0, 6'd0, 6'd1, 6'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Single Write");
        reset_dut();
        enable = 1;
        write = 1;
        @(posedge clock);
        #1;
        write = 0;

        #1;


        check_outputs(1'b0, 1'b0, 6'd0, 6'd1, 6'd1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Single Write then Single Read");
        reset_dut();
        enable = 1;


        write = 1;
        @(posedge clock);
        #1;
        write = 0;


        read = 1;
        @(posedge clock);
        #1;
        read = 0;


        #1;



        check_outputs(1'b1, 1'b0, 6'd1, 6'd2, 6'd1, 1'b0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        $display("Running testcase004: Fill FIFO to Full");
        reset_dut();
        enable = 1;
        write = 1;

        for (i = 0; i < 64; i = i + 1) begin
            @(posedge clock);
            #1;
        end
        write = 0;


        #1;



        check_outputs(1'b0, 1'b1, 6'd0, 6'd1, 6'd0, 1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        $display("Running testcase005: Read until Empty");
        reset_dut();
        enable = 1;


        write = 1;
        for (i = 0; i < 64; i = i + 1) begin
            @(posedge clock);
            #1;
        end
        write = 0;


        read = 1;
        for (i = 0; i < 64; i = i + 1) begin
            @(posedge clock);
            #1;
        end
        read = 0;


        #1;



        check_outputs(1'b1, 1'b0, 6'd0, 6'd1, 6'd0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Enable Signal Check");
        reset_dut();
        enable = 0;
        write = 1;
        @(posedge clock);
        #1;


        #1;



        check_outputs(1'b1, 1'b0, 6'd0, 6'd1, 6'd0, 1'b0);
    end
        endtask

    task testcase007;

    integer i;
    begin
        $display("Running testcase007: Simultaneous Read/Write");
        reset_dut();
        enable = 1;


        write = 1;
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clock);
            #1;
        end


        read = 1;
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clock);
            #1;
        end
        write = 0;
        read = 0;


        #1;



        check_outputs(1'b0, 1'b0, 6'd5, 6'd6, 6'd15, 1'b0);
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
        input expected_empty;
        input expected_full;
        input [5:0] expected_ram_raddr;
        input [5:0] expected_ram_raddr_next;
        input [5:0] expected_ram_waddr;
        input expected_ram_wen;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_ram_raddr === (expected_ram_raddr ^ ram_raddr ^ expected_ram_raddr) &&
                expected_ram_raddr_next === (expected_ram_raddr_next ^ ram_raddr_next ^ expected_ram_raddr_next) &&
                expected_ram_waddr === (expected_ram_waddr ^ ram_waddr ^ expected_ram_waddr) &&
                expected_ram_wen === (expected_ram_wen ^ ram_wen ^ expected_ram_wen)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, ram_raddr=%h, ram_raddr_next=%h, ram_waddr=%h, ram_wen=%b",
                         empty, full, ram_raddr, ram_raddr_next, ram_waddr, ram_wen);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, ram_raddr=%h, ram_raddr_next=%h, ram_waddr=%h, ram_wen=%b",
                         expected_empty, expected_full, expected_ram_raddr, expected_ram_raddr_next, expected_ram_waddr, expected_ram_wen);
                $display("  Got:      empty=%b, full=%b, ram_raddr=%h, ram_raddr_next=%h, ram_waddr=%h, ram_wen=%b",
                         empty, full, ram_raddr, ram_raddr_next, ram_waddr, ram_wen);
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
        $dumpvars(0,clock, enable, read, reset, write, empty, full, ram_raddr, ram_raddr_next, ram_waddr, ram_wen);
    end

endmodule
