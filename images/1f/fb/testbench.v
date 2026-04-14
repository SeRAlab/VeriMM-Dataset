`timescale 1ns/1ps

module nat_device_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg rst;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_device dut (
        .clk(clk),
        .ctrl(ctrl),
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .rst(rst),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ctrl = 0;
            internal_ip = 32'h0;
            external_ip = 32'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial state after reset", test_num);
            reset_dut();

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Adding a mapping", test_num);
            reset_dut();
            internal_ip = 32'hC0A80001;
            external_ip = 32'h08080808;
            ctrl = 1;
            @(posedge clk);
            #1;
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Removing an existing mapping", test_num);
            reset_dut();

            internal_ip = 32'h0A000001;
            external_ip = 32'h5D4B2211;
            ctrl = 1;
            @(posedge clk);
            #1;

            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Removing mapping when already inactive", test_num);
            reset_dut();
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Adding mapping when already active", test_num);
            reset_dut();

            internal_ip = 32'hC0A8010A;
            external_ip = 32'hD83AD2D2;
            ctrl = 1;
            @(posedge clk);
            #1;

            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Verify reset clears mapping", test_num);
            reset_dut();

            ctrl = 1;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_device Testbench");
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
        input expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%b",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%b",
                         expected_status);
                $display("  Got:      status=%b",
                         status);
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
        $dumpvars(0,clk, ctrl, external_ip, internal_ip, rst, status);
    end

endmodule
