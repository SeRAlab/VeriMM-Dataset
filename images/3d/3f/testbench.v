`timescale 1ns/1ps

module bluetooth_address_incrementer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire [3:0] address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_address_incrementer dut (
        .clk(clk),
        .enable(enable),
        .address(address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        @(posedge clk);


        if (address !== 4'd0) begin
            enable = 1;
            repeat(16) begin
                if (address === 4'd0) begin
                    enable = 0;
                end else begin
                    @(posedge clk);
                end
            end
            enable = 0;
        end
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Basic Increment (5 steps)", test_num);
        reset_dut();
        enable = 1;
        repeat(5) @(posedge clk);
        enable = 0;
        @(negedge clk);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Full Wrap Around (16 steps)", test_num);
        reset_dut();
        enable = 1;
        repeat(16) @(posedge clk);
        enable = 0;
        @(negedge clk);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Boundary Check (15 steps)", test_num);
        reset_dut();
        enable = 1;
        repeat(15) @(posedge clk);
        enable = 0;
        @(negedge clk);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Enable/Disable Toggle", test_num);
        reset_dut();
        enable = 1;
        repeat(3) @(posedge clk);
        enable = 0;
        repeat(4) @(posedge clk);
        enable = 1;
        repeat(2) @(posedge clk);
        enable = 0;
        @(negedge clk);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiple Wrap Arounds (34 steps)", test_num);
        reset_dut();
        enable = 1;
        repeat(34) @(posedge clk);
        enable = 0;
        @(negedge clk);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Single Step", test_num);
        reset_dut();
        enable = 1;
        @(posedge clk);
        enable = 0;
        @(negedge clk);
        #1;

        check_outputs(4'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_address_incrementer Testbench");
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
        input [3:0] expected_address;
        begin
            if (expected_address === (expected_address ^ address ^ expected_address)) begin
                $display("PASS");
                $display("  Outputs: address=%h",
                         address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h",
                         expected_address);
                $display("  Got:      address=%h",
                         address);
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
        $dumpvars(0,clk, enable, address);
    end

endmodule
