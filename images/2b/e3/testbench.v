`timescale 1ns/1ps

module virtual_memory_manager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] virtual_address;
    wire [31:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_manager dut (
        .clk(clk),
        .reset(reset),
        .virtual_address(virtual_address),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        virtual_address = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: VPN 0x00000, Offset 0x000", test_num);
        reset_dut();
        virtual_address = 32'h0000_0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0100_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: VPN 0x00000, Offset 0xABC", test_num);
        reset_dut();
        virtual_address = 32'h0000_0ABC;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0100_0ABC);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: VPN 0x00001, Offset 0x000", test_num);
        reset_dut();
        virtual_address = 32'h0000_1000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0100_1000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: VPN 0x00002, Offset 0xFFF", test_num);
        reset_dut();
        virtual_address = 32'h0000_2FFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0100_2FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: VPN 0x12345, Offset 0x678", test_num);
        reset_dut();
        virtual_address = 32'h1234_5678;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h5432_1678);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: VPN 0xFFFFF, Offset 0x000", test_num);
        reset_dut();
        virtual_address = 32'hFFFF_F000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_manager Testbench");
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
        input [31:0] expected_physical_address;
        begin
            if (expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: physical_address=%h",
                         physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_address=%h",
                         expected_physical_address);
                $display("  Got:      physical_address=%h",
                         physical_address);
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
        $dumpvars(0,clk, reset, virtual_address, physical_address);
    end

endmodule
