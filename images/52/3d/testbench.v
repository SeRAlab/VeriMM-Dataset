`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] regmel_addr;
    reg [44:0] regmel_in;
    reg regmel_wren;
    reg reset;
    wire [44:0] regmel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .regmel_addr(regmel_addr),
        .regmel_in(regmel_in),
        .regmel_wren(regmel_wren),
        .reset(reset),
        .regmel_out(regmel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        regmel_addr = 0;
        regmel_in = 0;
        regmel_wren = 0;
        #15;
        reset = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Post-Reset Verification (Addr 5)", test_num);
        reset_dut();
        regmel_addr = 5'd5;
        regmel_wren = 0;
        #10;
        #1;

        check_outputs(45'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write and Read (Addr 10)", test_num);
        reset_dut();
        @(posedge clk);
        regmel_addr = 5'd10;
        regmel_in = 45'h123456789ABC;
        regmel_wren = 1;
        @(posedge clk);
        regmel_wren = 0;
        #10;
        #1;

        check_outputs(45'h123456789ABC);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write Enable Inhibition (wren=0)", test_num);
        reset_dut();
        @(posedge clk);
        regmel_addr = 5'd7;
        regmel_in = 45'hFFFFFFFFFFFF;
        regmel_wren = 0;
        @(posedge clk);
        #10;
        #1;

        check_outputs(45'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Address (Addr 31)", test_num);
        reset_dut();
        @(posedge clk);
        regmel_addr = 5'd31;
        regmel_in = 45'h155555555555;
        regmel_wren = 1;
        @(posedge clk);
        regmel_wren = 0;
        #10;
        #1;

        check_outputs(45'h155555555555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overwriting Value (Addr 2)", test_num);
        reset_dut();
        @(posedge clk);
        regmel_addr = 5'd2;
        regmel_in = 45'hAAAA_AAAA_AAAA;
        regmel_wren = 1;
        @(posedge clk);
        regmel_in = 45'hBBBB_BBBB_BBBB;
        @(posedge clk);
        regmel_wren = 0;
        #10;
        #1;

        check_outputs(45'hBBBB_BBBB_BBBB);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Async Reset Mid-Operation", test_num);
        reset_dut();
        @(posedge clk);
        regmel_addr = 5'd15;
        regmel_in = 45'h1111_2222_3333;
        regmel_wren = 1;
        @(posedge clk);

        reset = 0;
        #5;
        reset = 1;
        regmel_wren = 0;
        #10;
        #1;

        check_outputs(45'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple Registers Consistency", test_num);
        reset_dut();

        @(posedge clk);
        regmel_addr = 5'd1;
        regmel_in = 45'hDEADBEEFCAFE;
        regmel_wren = 1;
        @(posedge clk);

        regmel_addr = 5'd2;
        regmel_in = 45'hCAFEBABE1234;
        @(posedge clk);
        regmel_wren = 0;

        regmel_addr = 5'd1;
        #10;
        #1;

        check_outputs(45'hDEADBEEFCAFE);
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
        input [44:0] expected_regmel_out;
        begin
            if (expected_regmel_out === (expected_regmel_out ^ regmel_out ^ expected_regmel_out)) begin
                $display("PASS");
                $display("  Outputs: regmel_out=%h",
                         regmel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regmel_out=%h",
                         expected_regmel_out);
                $display("  Got:      regmel_out=%h",
                         regmel_out);
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
        $dumpvars(0,clk, regmel_addr, regmel_in, regmel_wren, reset, regmel_out);
    end

endmodule
