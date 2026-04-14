`timescale 1ns/1ps

module mmu_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg valid;
    reg [15:0] virtual_addr;
    wire [31:0] physical_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mmu dut (
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .virtual_addr(virtual_addr),
        .physical_addr(physical_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        valid = 0;
        virtual_addr = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Translate VA 0x0000 (Entry 0)", test_num);
        reset_dut();
        virtual_addr = 16'h0000;
        valid = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h11110000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Translate VA 0x0001 (Entry 1)", test_num);
        reset_dut();
        virtual_addr = 16'h0001;
        valid = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h22220000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Translate VA 0x0002 (Entry 2)", test_num);
        reset_dut();
        virtual_addr = 16'h0002;
        valid = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h33330000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Translate VA 0x0003 (Entry 3)", test_num);
        reset_dut();
        virtual_addr = 16'h0003;
        valid = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h44440000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Translate non-existent VA 0xFFFF", test_num);
        reset_dut();
        virtual_addr = 16'hFFFF;
        valid = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Translate VA 0x0000 with valid=0", test_num);
        reset_dut();
        virtual_addr = 16'h0000;
        valid = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Check output during reset", test_num);
        reset = 1;
        valid = 1;
        virtual_addr = 16'h0000;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hFFFFFFFF);
        reset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mmu Testbench");
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
        input [31:0] expected_physical_addr;
        begin
            if (expected_physical_addr === (expected_physical_addr ^ physical_addr ^ expected_physical_addr)) begin
                $display("PASS");
                $display("  Outputs: physical_addr=%h",
                         physical_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_addr=%h",
                         expected_physical_addr);
                $display("  Got:      physical_addr=%h",
                         physical_addr);
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
        $dumpvars(0,clk, reset, valid, virtual_addr, physical_addr);
    end

endmodule
