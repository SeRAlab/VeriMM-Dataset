`timescale 1ns/1ps

module shift_register8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg dir;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register8bit dut (
        .clk(clk),
        .data(data),
        .dir(dir),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 8'b0;
            dir = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Shift Left - 8'h01", test_num);
            reset_dut();
            data = 8'h01;
            dir = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift Left - 8'h80 (MSB shift out)", test_num);
            reset_dut();
            data = 8'h80;
            dir = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift Left - 8'hFF", test_num);
            reset_dut();
            data = 8'hFF;
            dir = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift Right - 8'h80", test_num);
            reset_dut();
            data = 8'h80;
            dir = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Shift Right - 8'h01 (LSB shift out)", test_num);
            reset_dut();
            data = 8'h01;
            dir = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Shift Right - 8'hAA", test_num);
            reset_dut();
            data = 8'hAA;
            dir = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Shift Left - 8'h00", test_num);
            reset_dut();
            data = 8'h00;
            dir = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Shift Right - 8'hFF", test_num);
            reset_dut();
            data = 8'hFF;
            dir = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h7F);
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
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, data, dir, q);
    end

endmodule
