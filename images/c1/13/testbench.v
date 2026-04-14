`timescale 1ns/1ps

module vga_vtim_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Tgate;
    reg [7:0] Tgdel;
    reg [15:0] Tlen;
    reg [7:0] Tsync;
    reg clk;
    reg ena;
    reg rst;
    wire Done;
    wire Gate;
    wire Sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vga_vtim dut (
        .Tgate(Tgate),
        .Tgdel(Tgdel),
        .Tlen(Tlen),
        .Tsync(Tsync),
        .clk(clk),
        .ena(ena),
        .rst(rst),
        .Done(Done),
        .Gate(Gate),
        .Sync(Sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ena = 0;
            Tsync = 0;
            Tgdel = 0;
            Tgate = 0;
            Tlen = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            Tsync = 8'd5;
            Tgdel = 8'd5;
            Tgate = 16'd10;
            Tlen  = 16'd30;
            ena = 1;

            repeat(30) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            Tsync = 8'd10;
            Tgdel = 8'd5;
            Tgate = 16'd10;
            Tlen  = 16'd40;
            ena = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            Tsync = 8'd2;
            Tgdel = 8'd2;
            Tgate = 16'd5;
            Tlen  = 16'd15;
            ena = 1;
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            Tsync = 8'd5;
            Tgdel = 8'd5;
            Tgate = 16'd10;
            Tlen  = 16'd30;
            ena = 1;
            repeat(5) @(posedge clk);
            ena = 0;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            Tsync = 8'd10;
            Tgdel = 8'd10;
            Tgate = 16'd10;
            Tlen  = 16'd50;
            ena = 1;
            repeat(15) @(posedge clk);
            rst = 1;
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vga_vtim Testbench");
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
        input expected_Done;
        input expected_Gate;
        input expected_Sync;
        begin
            if (expected_Done === (expected_Done ^ Done ^ expected_Done) &&
                expected_Gate === (expected_Gate ^ Gate ^ expected_Gate) &&
                expected_Sync === (expected_Sync ^ Sync ^ expected_Sync)) begin
                $display("PASS");
                $display("  Outputs: Done=%b, Gate=%b, Sync=%b",
                         Done, Gate, Sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Done=%b, Gate=%b, Sync=%b",
                         expected_Done, expected_Gate, expected_Sync);
                $display("  Got:      Done=%b, Gate=%b, Sync=%b",
                         Done, Gate, Sync);
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
        $dumpvars(0,Tgate, Tgdel, Tlen, Tsync, clk, ena, rst, Done, Gate, Sync);
    end

endmodule
