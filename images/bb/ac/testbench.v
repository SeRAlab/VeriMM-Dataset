`timescale 1ns/1ps

module shift_register8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg si;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register8bit dut (
        .clk(clk),
        .rst(rst),
        .si(si),
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
            si = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in 0xFF (all ones)", test_num);
            reset_dut();
            si = 1;
            repeat (8) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in alternating 10101010 (0xAA)", test_num);
            reset_dut();
            repeat (4) begin
                si = 1; @(posedge clk); #1;
                si = 0; @(posedge clk); #1;
            end
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in alternating 01010101 (0x55)", test_num);
            reset_dut();
            repeat (4) begin
                si = 0; @(posedge clk); #1;
                si = 1; @(posedge clk); #1;
            end
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift in pattern 0x12", test_num);
            pattern = 8'h12;
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                si = pattern[i];
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overflow check (shift 16 bits)", test_num);
            reset_dut();
            si = 1;
            repeat (8) begin
                @(posedge clk);
                #1;
            end
            si = 0;
            repeat (8) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register8bit Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, rst, si, q);
    end

endmodule
