`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN_r1__write;
    reg EN_r2__write;
    reg RST_N;
    reg [31:0] r1__write_1;
    reg [31:0] r2__write_1;
    wire RDY_r1__read;
    wire RDY_r1__write;
    wire RDY_r2__read;
    wire RDY_r2__write;
    wire [31:0] r1__read;
    wire [31:0] r2__read;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN_r1__write(EN_r1__write),
        .EN_r2__write(EN_r2__write),
        .RST_N(RST_N),
        .r1__write_1(r1__write_1),
        .r2__write_1(r2__write_1),
        .RDY_r1__read(RDY_r1__read),
        .RDY_r1__write(RDY_r1__write),
        .RDY_r2__read(RDY_r2__read),
        .RDY_r2__write(RDY_r2__write),
        .r1__read(r1__read),
        .r2__read(r2__read)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST_N = 0;
            EN_r1__write = 0;
            EN_r2__write = 0;
            r1__write_1 = 32'h0;
            r2__write_1 = 32'h0;
            #10;
            RST_N = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Write through Port 1", test_num);
            reset_dut();
            @(posedge CLK);
            r1__write_1 = 32'hAAAA_5555;
            EN_r1__write = 1;
            @(posedge CLK);
            #1;
            EN_r1__write = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 32'hAAAA_5555, 32'hAAAA_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Write through Port 2", test_num);
            reset_dut();
            @(posedge CLK);
            r2__write_1 = 32'h1234_5678;
            EN_r2__write = 1;
            @(posedge CLK);
            #1;
            EN_r2__write = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 32'h1234_5678, 32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: EHR Bypass (r2_read sees r1_write immediately)", test_num);
            reset_dut();
            @(posedge CLK);
            r1__write_1 = 32'hFEED_BEEF;
            EN_r1__write = 1;
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 32'h0, 32'hFEED_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Concurrent Writes Priority", test_num);
            reset_dut();
            @(posedge CLK);
            r1__write_1 = 32'h1111_1111;
            r2__write_1 = 32'h2222_2222;
            EN_r1__write = 1;
            EN_r2__write = 1;
            @(posedge CLK);
            #1;
            EN_r1__write = 0;
            EN_r2__write = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 32'h2222_2222, 32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Data Persistence", test_num);
            reset_dut();
            @(posedge CLK);
            r1__write_1 = 32'hDEAD_BEEF;
            EN_r1__write = 1;
            @(posedge CLK);
            #1;
            EN_r1__write = 0;
            r1__write_1 = 32'h0;
            repeat(3) @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 32'hDEAD_BEEF, 32'hDEAD_BEEF);
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
        input expected_RDY_r1__read;
        input expected_RDY_r1__write;
        input expected_RDY_r2__read;
        input expected_RDY_r2__write;
        input [31:0] expected_r1__read;
        input [31:0] expected_r2__read;
        begin
            if (expected_RDY_r1__read === (expected_RDY_r1__read ^ RDY_r1__read ^ expected_RDY_r1__read) &&
                expected_RDY_r1__write === (expected_RDY_r1__write ^ RDY_r1__write ^ expected_RDY_r1__write) &&
                expected_RDY_r2__read === (expected_RDY_r2__read ^ RDY_r2__read ^ expected_RDY_r2__read) &&
                expected_RDY_r2__write === (expected_RDY_r2__write ^ RDY_r2__write ^ expected_RDY_r2__write) &&
                expected_r1__read === (expected_r1__read ^ r1__read ^ expected_r1__read) &&
                expected_r2__read === (expected_r2__read ^ r2__read ^ expected_r2__read)) begin
                $display("PASS");
                $display("  Outputs: RDY_r1__read=%b, RDY_r1__write=%b, RDY_r2__read=%b, RDY_r2__write=%b, r1__read=%h, r2__read=%h",
                         RDY_r1__read, RDY_r1__write, RDY_r2__read, RDY_r2__write, r1__read, r2__read);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RDY_r1__read=%b, RDY_r1__write=%b, RDY_r2__read=%b, RDY_r2__write=%b, r1__read=%h, r2__read=%h",
                         expected_RDY_r1__read, expected_RDY_r1__write, expected_RDY_r2__read, expected_RDY_r2__write, expected_r1__read, expected_r2__read);
                $display("  Got:      RDY_r1__read=%b, RDY_r1__write=%b, RDY_r2__read=%b, RDY_r2__write=%b, r1__read=%h, r2__read=%h",
                         RDY_r1__read, RDY_r1__write, RDY_r2__read, RDY_r2__write, r1__read, r2__read);
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
        $dumpvars(0,CLK, EN_r1__write, EN_r2__write, RST_N, r1__write_1, r2__write_1, RDY_r1__read, RDY_r1__write, RDY_r2__read, RDY_r2__write, r1__read, r2__read);
    end

endmodule
