`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ps2_clk;
    reg ps2_data;
    wire [7:0] ps2_code;
    wire ps2_event;
    wire ps2_ext;
    wire ps2_up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .ps2_code(ps2_code),
        .ps2_event(ps2_event),
        .ps2_ext(ps2_ext),
        .ps2_up(ps2_up)
    );

    // Clock generation (10ns period)
    initial begin
        ps2_clk = 0;
        forever #5 ps2_clk = ~ps2_clk;
    end

        task reset_dut;

        begin
            ps2_data = 1;
            repeat (5) @(posedge ps2_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Normal Key Press (0x1C)", test_num);
            reset_dut();
            send_ps2_byte(8'h1C);

            #1;


            check_outputs(8'h1C, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Normal Key Release (0xF0, 0x1C)", test_num);
            reset_dut();
            send_ps2_byte(8'hF0);
            send_ps2_byte(8'h1C);

            #1;


            check_outputs(8'h1C, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Extended Key Press (0xE0, 0x74)", test_num);
            reset_dut();
            send_ps2_byte(8'hE0);
            send_ps2_byte(8'h74);

            #1;


            check_outputs(8'h74, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Extended Key Release (0xE0, 0xF0, 0x74)", test_num);
            reset_dut();
            send_ps2_byte(8'hE0);
            send_ps2_byte(8'hF0);
            send_ps2_byte(8'h74);

            #1;


            check_outputs(8'h74, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Different Key Press (0x1D)", test_num);
            reset_dut();
            send_ps2_byte(8'h1D);

            #1;


            check_outputs(8'h1D, 1'b1, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_ps2_code;
        input expected_ps2_event;
        input expected_ps2_ext;
        input expected_ps2_up;
        begin
            if (expected_ps2_code === (expected_ps2_code ^ ps2_code ^ expected_ps2_code) &&
                expected_ps2_event === (expected_ps2_event ^ ps2_event ^ expected_ps2_event) &&
                expected_ps2_ext === (expected_ps2_ext ^ ps2_ext ^ expected_ps2_ext) &&
                expected_ps2_up === (expected_ps2_up ^ ps2_up ^ expected_ps2_up)) begin
                $display("PASS");
                $display("  Outputs: ps2_code=%h, ps2_event=%b, ps2_ext=%b, ps2_up=%b",
                         ps2_code, ps2_event, ps2_ext, ps2_up);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ps2_code=%h, ps2_event=%b, ps2_ext=%b, ps2_up=%b",
                         expected_ps2_code, expected_ps2_event, expected_ps2_ext, expected_ps2_up);
                $display("  Got:      ps2_code=%h, ps2_event=%b, ps2_ext=%b, ps2_up=%b",
                         ps2_code, ps2_event, ps2_ext, ps2_up);
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
        $dumpvars(0,ps2_clk, ps2_data, ps2_code, ps2_event, ps2_ext, ps2_up);
    end

endmodule
