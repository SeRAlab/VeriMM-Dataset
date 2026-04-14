`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addr0;
    reg [12:0] addr1;
    reg ce0;
    reg ce1;
    reg clk;
    reg [7:0] d0;
    reg [7:0] d1;
    reg we0;
    reg we1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .addr1(addr1),
        .ce0(ce0),
        .ce1(ce1),
        .clk(clk),
        .d0(d0),
        .d1(d1),
        .we0(we0),
        .we1(we1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr0 = 0; addr1 = 0;
            ce0 = 0; ce1 = 0;
            we0 = 0; we1 = 0;
            d0 = 0; d1 = 0;
            exp_q0 = 0; exp_q1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk);
            addr0 = 13'd10; d0 = 8'hA5; we0 = 1; ce0 = 1;
            @(posedge clk);
            we0 = 0; ce0 = 0;

            @(posedge clk);
            addr0 = 13'd10; ce0 = 1; we0 = 0;
            @(posedge clk);
            #1;
            exp_q0 = 8'hA5; exp_q1 = q1;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge clk);
            addr1 = 13'd2000; d1 = 8'h5A; we1 = 1; ce1 = 1;
            @(posedge clk);
            we1 = 0; ce1 = 0;

            @(posedge clk);
            addr1 = 13'd2000; ce1 = 1; we1 = 0;
            @(posedge clk);
            #1;
            exp_q0 = q0; exp_q1 = 8'h5A;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge clk);
            addr0 = 13'd500; d0 = 8'hFF; we0 = 1; ce0 = 1;
            @(posedge clk);
            we0 = 0; ce0 = 0;

            @(posedge clk);
            addr1 = 13'd500; ce1 = 1; we1 = 0;
            @(posedge clk);
            #1;
            exp_q0 = q0; exp_q1 = 8'hFF;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            addr0 = 13'd100; d0 = 8'h11; we0 = 1; ce0 = 1;
            addr1 = 13'd101; d1 = 8'h22; we1 = 1; ce1 = 1;
            @(posedge clk);
            we0 = 0; we1 = 0;

            addr0 = 13'd100; ce0 = 1;
            addr1 = 13'd101; ce1 = 1;
            @(posedge clk);
            #1;
            exp_q0 = 8'h11; exp_q1 = 8'h22;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            addr0 = 13'd5759; d0 = 8'h88; we0 = 1; ce0 = 1;
            @(posedge clk);
            we0 = 0;
            @(posedge clk);
            addr0 = 13'd5759; ce0 = 1;
            @(posedge clk);
            #1;
            exp_q0 = 8'h88; exp_q1 = q1;
            #1;

            check_outputs();
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge clk);
            addr0 = 13'd50; d0 = 8'hAA; we0 = 1; ce0 = 1;
            @(posedge clk);

            addr0 = 13'd50; d0 = 8'hBB; we0 = 1; ce0 = 0;
            @(posedge clk);

            we0 = 0; ce0 = 1;
            @(posedge clk);
            #1;
            exp_q0 = 8'hAA; exp_q1 = q1;
            #1;

            check_outputs();
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,addr0, addr1, ce0, ce1, clk, d0, d1, we0, we1);
    end

endmodule
