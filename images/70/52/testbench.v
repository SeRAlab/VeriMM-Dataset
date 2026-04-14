`timescale 1ns/1ps

module bidirectional_shift_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg dir;
    reg rst;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidirectional_shift dut (
        .clk(clk),
        .data(data),
        .dir(dir),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 16'h0000;
            dir = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            data = 16'hFFFF;
            rst = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Synchronous Reset Check", test_num);
            #1;

            check_outputs(16'h0000);
            rst = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 16'h0001;
            dir = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Left Shift (0x0001 -> 0x0002)", test_num);
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 16'h8000;
            dir = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Left Shift MSB Out (0x8000 -> 0x0000)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 16'h8000;
            dir = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Right Shift (0x8000 -> 0x4000)", test_num);
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 16'h0001;
            dir = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Right Shift LSB Out (0x0001 -> 0x0000)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 16'hFFFF;
            dir = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Left Shift All Ones (0xFFFF -> 0xFFFE)", test_num);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data = 16'hFFFF;
            dir = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Right Shift All Ones (0xFFFF -> 0x7FFF)", test_num);
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data = 16'h1234;
            dir = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Left Shift Pattern (0x1234 -> 0x2468)", test_num);
            #1;

            check_outputs(16'h2468);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            data = 16'h1234;
            dir = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Right Shift Pattern (0x1234 -> 0x091A)", test_num);
            #1;

            check_outputs(16'h091A);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            data = 16'hFFFF;
            dir = 1;
            rst = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Reset priority over data", test_num);
            #1;

            check_outputs(16'h0000);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bidirectional_shift Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, dir, rst, q);
    end

endmodule
