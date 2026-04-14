`timescale 1ns/1ps

module td_mode_selector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] ctrl;
    reg rst;
    wire [3:0] td_mode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    td_mode_selector dut (
        .clk(clk),
        .ctrl(ctrl),
        .rst(rst),
        .td_mode(td_mode)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ctrl = 9'b0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            ctrl = 9'b000000000;
            @(posedge clk);
            #2;
            $display("Testcase 001: ctrl=000, expected td_mode=0000");
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            ctrl = 9'b000000001;
            @(posedge clk);
            #2;
            $display("Testcase 002: ctrl=001, expected td_mode=1000");
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            ctrl = 9'b000000010;
            @(posedge clk);
            #2;
            $display("Testcase 003: ctrl=010, expected td_mode=0100");
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            ctrl = 9'b000000011;
            @(posedge clk);
            #2;
            $display("Testcase 004: ctrl=011, expected td_mode=1100");
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            ctrl = 9'b000000100;
            @(posedge clk);
            #2;
            $display("Testcase 005: ctrl=100, expected td_mode=0010");
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            ctrl = 9'b000000101;
            @(posedge clk);
            #2;
            $display("Testcase 006: ctrl=101, expected td_mode=1010");
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            ctrl = 9'b000000110;
            @(posedge clk);
            #2;
            $display("Testcase 007: ctrl=110, expected td_mode=0101");
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            ctrl = 9'b000000111;
            @(posedge clk);
            #2;
            $display("Testcase 008: ctrl=111, expected td_mode=1111");
            #1;

            check_outputs(4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("td_mode_selector Testbench");
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
        input [3:0] expected_td_mode;
        begin
            if (expected_td_mode === (expected_td_mode ^ td_mode ^ expected_td_mode)) begin
                $display("PASS");
                $display("  Outputs: td_mode=%h",
                         td_mode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: td_mode=%h",
                         expected_td_mode);
                $display("  Got:      td_mode=%h",
                         td_mode);
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
        $dumpvars(0,clk, ctrl, rst, td_mode);
    end

endmodule
