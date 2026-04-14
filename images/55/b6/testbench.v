`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr0;
    reg [15:0] addr1;
    reg [15:0] addr2;
    reg [15:0] addr3;
    reg [1:0] addr_sel;
    reg clk;
    wire [15:0] a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .addr1(addr1),
        .addr2(addr2),
        .addr3(addr3),
        .addr_sel(addr_sel),
        .clk(clk),
        .a(a)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr0 = 16'h0000;
            addr1 = 16'h0000;
            addr2 = 16'h0000;
            addr3 = 16'h0000;
            addr_sel = 2'b00;

            @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Select addr0", test_num);
            addr0 = 16'hAAAA;
            addr1 = 16'h1111;
            addr2 = 16'h2222;
            addr3 = 16'h3333;
            addr_sel = 2'b00;
            @(negedge clk);
            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Select addr1", test_num);
            addr0 = 16'h0000;
            addr1 = 16'hBBBB;
            addr2 = 16'hCCCC;
            addr3 = 16'hDDDD;
            addr_sel = 2'b01;
            @(negedge clk);
            #2;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Select addr2", test_num);
            addr0 = 16'h1234;
            addr1 = 16'h5678;
            addr2 = 16'h9ABC;
            addr3 = 16'hDEF0;
            addr_sel = 2'b10;
            @(negedge clk);
            #2;
            #1;

            check_outputs(16'h9ABC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Select addr3", test_num);
            addr0 = 16'hFFFF;
            addr1 = 16'hEEEE;
            addr2 = 16'hDDDD;
            addr3 = 16'hCCCC;
            addr_sel = 2'b11;
            @(negedge clk);
            #2;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Check synchronous selection update", test_num);


            addr0 = 16'h1111;
            addr1 = 16'h2222;
            addr_sel = 2'b00;
            @(negedge clk);
            #2;


            @(posedge clk);
            addr_sel = 2'b01;
            #1;


            if (a !== 16'h1111) begin
                $display("Warning: Output changed before negative edge - checking synchronous requirement.");
            end


            @(negedge clk);
            #2;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Data update with constant selection", test_num);
            addr2 = 16'h5555;
            addr_sel = 2'b10;
            @(negedge clk);
            #2;


            addr2 = 16'h6666;
            #2;




            @(negedge clk);
            #2;
            #1;

            check_outputs(16'h6666);
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
        input [15:0] expected_a;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a)) begin
                $display("PASS");
                $display("  Outputs: a=%h",
                         a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h",
                         expected_a);
                $display("  Got:      a=%h",
                         a);
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
        $dumpvars(0,addr0, addr1, addr2, addr3, addr_sel, clk, a);
    end

endmodule
