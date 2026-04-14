`timescale 1ns/1ps

module siso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg s_in;
    wire [4:0] s_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    siso_shift_register dut (
        .clk(clk),
        .rst(rst),
        .s_in(s_in),
        .s_out(s_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            s_in = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Reset State", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in five 1s", test_num);
            reset_dut();
            s_in = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in 10101", test_num);
            reset_dut();


            s_in = 1; @(posedge clk);
            s_in = 0; @(posedge clk);
            s_in = 1; @(posedge clk);
            s_in = 0; @(posedge clk);
            s_in = 1; @(posedge clk);
            #1;


            #1;



            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow check (7 bits)", test_num);
            reset_dut();


            s_in = 1; @(posedge clk);
            s_in = 1; @(posedge clk);
            s_in = 0; @(posedge clk);
            s_in = 0; @(posedge clk);
            s_in = 1; @(posedge clk);
            s_in = 1; @(posedge clk);
            s_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(5'b01100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupted sequence with Reset", test_num);
            reset_dut();
            s_in = 1; @(posedge clk);
            s_in = 1; @(posedge clk);

            rst = 1; @(posedge clk);
            #1 rst = 0;
            s_in = 1; @(posedge clk);
            s_in = 0; @(posedge clk);
            s_in = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(5'b10100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("siso_shift_register Testbench");
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
        input [4:0] expected_s_out;
        begin
            if (expected_s_out === (expected_s_out ^ s_out ^ expected_s_out)) begin
                $display("PASS");
                $display("  Outputs: s_out=%h",
                         s_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s_out=%h",
                         expected_s_out);
                $display("  Got:      s_out=%h",
                         s_out);
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
        $dumpvars(0,clk, rst, s_in, s_out);
    end

endmodule
