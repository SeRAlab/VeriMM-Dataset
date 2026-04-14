`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d_in;
    reg re;
    reg rst;
    reg we;
    wire d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .clk(clk),
        .d_in(d_in),
        .re(re),
        .rst(rst),
        .we(we),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            we = 0;
            re = 0;
            d_in = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 1, Read 1", test_num);
            reset_dut();

            @(posedge clk);
            we <= 1;
            d_in <= 1;

            @(posedge clk);
            we <= 0;
            re <= 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 0, Read 0", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1;
            d_in <= 1;

            @(posedge clk);
            we <= 1;
            d_in <= 0;

            @(posedge clk);
            we <= 0;
            re <= 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence (WE check)", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1;
            d_in <= 1;


            @(posedge clk);
            we <= 0;
            d_in <= 0;

            @(posedge clk);
            re <= 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read Enable logic", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1;
            d_in <= 1;


            @(posedge clk);
            we <= 0;
            re <= 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset check", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1;
            d_in <= 1;

            @(posedge clk);
            we <= 0;
            re <= 1;

            @(posedge clk);
            #1;

            if(d_out !== 1'b1) $display("Pre-reset check failed");


            rst = 1;
            #2;
            rst = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maintain state", test_num);
            reset_dut();

            @(posedge clk);
            we <= 1;
            d_in <= 1;

            @(posedge clk);
            we <= 0;
            d_in <= 0;

            repeat(5) @(posedge clk);

            re <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        input expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%b",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%b",
                         expected_d_out);
                $display("  Got:      d_out=%b",
                         d_out);
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
        $dumpvars(0,clk, d_in, re, rst, we, d_out);
    end

endmodule
