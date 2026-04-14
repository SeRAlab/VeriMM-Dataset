`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr1;
    reg [4:0] addr2;
    reg [4:0] addw;
    reg clk;
    reg [3:0] data;
    reg en;
    wire [3:0] content1;
    wire [3:0] content2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .addw(addw),
        .clk(clk),
        .data(data),
        .en(en),
        .content1(content1),
        .content2(content2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            en = 0;
            addr1 = 0;
            addr2 = 0;
            addw = 0;
            data = 0;


            @(negedge clk);
            for (i = 0; i < 5; i = i + 1) begin
                en = 1;
                addw = i;
                data = 4'h0;
                @(negedge clk);
            end
            en = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Dual Port Read", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; addw = 5'd0; data = 4'hA;
            @(negedge clk);
            en = 1; addw = 5'd1; data = 4'h5;
            @(negedge clk);
            en = 0;

            addr1 = 5'd0;
            addr2 = 5'd1;
            #2;
            #1;

            check_outputs(4'hA, 4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify all valid addresses", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; addw = 5'd2; data = 4'hC;
            @(negedge clk);
            en = 1; addw = 5'd3; data = 4'hD;
            @(negedge clk);
            en = 1; addw = 5'd4; data = 4'hE;
            @(negedge clk);
            en = 0;

            addr1 = 5'd2;
            addr2 = 5'd4;
            #2;
            #1;

            check_outputs(4'hC, 4'hE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Dual read from same address", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; addw = 5'd2; data = 4'h9;
            @(negedge clk);
            en = 0;

            addr1 = 5'd2;
            addr2 = 5'd2;
            #2;
            #1;

            check_outputs(4'h9, 4'h9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable (en) functionality", test_num);
            reset_dut();


            @(negedge clk);
            en = 1; addw = 5'd3; data = 4'h7;
            @(negedge clk);

            en = 0; addw = 5'd3; data = 4'hF;
            @(negedge clk);

            addr1 = 5'd3;
            addr2 = 5'd0;
            #2;

            #1;


            check_outputs(4'h7, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwrite existing memory", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; addw = 5'd0; data = 4'h1;
            @(negedge clk);
            en = 1; addw = 5'd0; data = 4'hB;
            @(negedge clk);
            en = 0;

            addr1 = 5'd0;
            addr2 = 5'd0;
            #2;
            #1;

            check_outputs(4'hB, 4'hB);
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
        input [3:0] expected_content1;
        input [3:0] expected_content2;
        begin
            if (expected_content1 === (expected_content1 ^ content1 ^ expected_content1) &&
                expected_content2 === (expected_content2 ^ content2 ^ expected_content2)) begin
                $display("PASS");
                $display("  Outputs: content1=%h, content2=%h",
                         content1, content2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: content1=%h, content2=%h",
                         expected_content1, expected_content2);
                $display("  Got:      content1=%h, content2=%h",
                         content1, content2);
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
        $dumpvars(0,addr1, addr2, addw, clk, data, en, content1, content2);
    end

endmodule
