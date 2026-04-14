`timescale 1ns/1ps

module VMU_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] virtual_address;
    wire [3:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VMU dut (
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
        virtual_address = 4'h0;
        @(posedge clk);
        #2;
        reset = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Verify reset state", test_num);
        reset = 1;
        virtual_address = 4'hA;
        @(posedge clk);
        #2;

        #1;


        check_outputs(4'h0);
        reset = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: VA 0x0 -> PA 0x0", test_num);
        reset_dut();
        virtual_address = 4'h0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: VA 0x5 -> PA 0x5", test_num);
        reset_dut();
        virtual_address = 4'h5;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: VA 0xA -> PA 0xA", test_num);
        reset_dut();
        virtual_address = 4'hA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: VA 0xF -> PA 0xF", test_num);
        reset_dut();
        virtual_address = 4'hF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VMU Testbench");
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
        input [3:0] expected_physical_address;
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
