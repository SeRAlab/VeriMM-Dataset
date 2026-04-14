`timescale 1ns/1ps

module register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg en;
    reg reset;
    wire [15:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .reset(reset),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            data_in = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write 0xABCD with en=1", test_num);
            reset_dut();
            data_in = 16'hABCD;
            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Data hold with en=0", test_num);
            reset_dut();

            data_in = 16'h55AA;
            en = 1;
            @(posedge clk);
            #2;

            en = 0;
            data_in = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Overwriting data", test_num);
            reset_dut();
            data_in = 16'h1111;
            en = 1;
            @(posedge clk);
            #2;
            data_in = 16'h2222;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Asynchronous Reset behavior", test_num);
            reset_dut();
            data_in = 16'hFFFF;
            en = 1;
            @(posedge clk);
            #2;

            reset = 1;
            #1;
            #1;

            check_outputs(16'h0000);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Boundary value 0xFFFF", test_num);
            reset_dut();
            data_in = 16'hFFFF;
            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_16bit Testbench");
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
        input [15:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, data_in, en, reset, reg_out);
    end

endmodule
