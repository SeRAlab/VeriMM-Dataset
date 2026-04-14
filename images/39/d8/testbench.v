`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr_ch1;
    reg [3:0] addr_ch2;
    reg clk;
    reg rd_en_ch1;
    reg rd_en_ch2;
    reg rst;
    reg wr_en_ch1;
    reg wr_en_ch2;
    wire active_ch1;
    wire active_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr_ch1(addr_ch1),
        .addr_ch2(addr_ch2),
        .clk(clk),
        .rd_en_ch1(rd_en_ch1),
        .rd_en_ch2(rd_en_ch2),
        .rst(rst),
        .wr_en_ch1(wr_en_ch1),
        .wr_en_ch2(wr_en_ch2),
        .active_ch1(active_ch1),
        .active_ch2(active_ch2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr_ch1 = 4'b0;
            addr_ch2 = 4'b0;
            rd_en_ch1 = 0;
            rd_en_ch2 = 0;
            wr_en_ch1 = 0;
            wr_en_ch2 = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: System Reset State", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Channel 1 Read Activity", test_num);
            reset_dut();
            addr_ch1 = 4'hA;
            rd_en_ch1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Channel 2 Write Activity", test_num);
            reset_dut();
            addr_ch2 = 4'h5;
            wr_en_ch2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Simultaneous Operation", test_num);
            reset_dut();
            addr_ch1 = 4'h1;
            rd_en_ch1 = 1;
            addr_ch2 = 4'hE;
            wr_en_ch2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Channel 1 Multiple Signals", test_num);
            reset_dut();
            rd_en_ch1 = 1;
            wr_en_ch1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Idle with Address Inputs", test_num);
            reset_dut();
            addr_ch1 = 4'hF;
            addr_ch2 = 4'h3;
            rd_en_ch1 = 0;
            wr_en_ch1 = 0;
            rd_en_ch2 = 0;
            wr_en_ch2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Toggle Operation (Active to Inactive)", test_num);
            reset_dut();

            rd_en_ch1 = 1;
            rd_en_ch2 = 1;
            @(posedge clk);
            #1;

            rd_en_ch1 = 0;
            rd_en_ch2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_active_ch1;
        input expected_active_ch2;
        begin
            if (expected_active_ch1 === (expected_active_ch1 ^ active_ch1 ^ expected_active_ch1) &&
                expected_active_ch2 === (expected_active_ch2 ^ active_ch2 ^ expected_active_ch2)) begin
                $display("PASS");
                $display("  Outputs: active_ch1=%b, active_ch2=%b",
                         active_ch1, active_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_ch1=%b, active_ch2=%b",
                         expected_active_ch1, expected_active_ch2);
                $display("  Got:      active_ch1=%b, active_ch2=%b",
                         active_ch1, active_ch2);
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
        $dumpvars(0,addr_ch1, addr_ch2, clk, rd_en_ch1, rd_en_ch2, rst, wr_en_ch1, wr_en_ch2, active_ch1, active_ch2);
    end

endmodule
