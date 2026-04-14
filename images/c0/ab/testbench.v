`timescale 1ns/1ps

module expand_key_type_B_192_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [191:0] in;
    wire [191:0] out_1;
    wire [127:0] out_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    expand_key_type_B_192 dut (
        .clk(clk),
        .in(in),
        .out_1(out_1),
        .out_2(out_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in <= 192'h0;


            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            test_num = 1;
            reset_dut();
            in = 192'h0;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(192'h0, 128'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones");
            test_num = 2;
            reset_dut();
            in = {6{32'hFFFFFFFF}};







            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(192'hFFFFFFFF_FFFFFFFF_00000000_FFFFFFFF_00000000_FFFFFFFF,
                          128'h00000000_FFFFFFFF_00000000_FFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simple Incremental XOR Chain");
            test_num = 3;
            reset_dut();

            in = 192'h00000001_00000002_00000003_00000004_00000005_00000006;






            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(192'h00000001_00000002_00000001_00000005_00000000_00000006,
                          128'h00000001_00000005_00000000_00000006);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Walking Bit Pattern");
            test_num = 4;
            reset_dut();

            in = 192'h80000000_40000000_20000000_10000000_08000000_04000000;




            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(192'h80000000_40000000_60000000_70000000_78000000_7C000000,
                          128'h60000000_70000000_78000000_7C000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Random Hex Pattern");
            test_num = 5;
            reset_dut();

            in = 192'hAABBCCDD_11223344_55667788_99AABBCC_DDEEFF00_12345678;




            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(192'hAABBCCDD_11223344_444444CC_DDEEFE70_00000170_12345708,
                          128'h444444CC_DDEEFE70_00000170_12345708);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("expand_key_type_B_192 Testbench");
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
        input [191:0] expected_out_1;
        input [127:0] expected_out_2;
        begin
            if (expected_out_1 === (expected_out_1 ^ out_1 ^ expected_out_1) &&
                expected_out_2 === (expected_out_2 ^ out_2 ^ expected_out_2)) begin
                $display("PASS");
                $display("  Outputs: out_1=%h, out_2=%h",
                         out_1, out_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_1=%h, out_2=%h",
                         expected_out_1, expected_out_2);
                $display("  Got:      out_1=%h, out_2=%h",
                         out_1, out_2);
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
        $dumpvars(0,clk, in, out_1, out_2);
    end

endmodule
