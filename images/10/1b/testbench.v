`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg re;
    reg rst;
    reg we;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .clk(clk),
        .d(d),
        .re(re),
        .rst(rst),
        .we(we),
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
            d = 0;
            we = 0;
            re = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset Check", test_num);
            reset_dut();
            re = 1;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write '1' and Read", test_num);
            reset_dut();
            @(posedge clk);
            d = 1;
            we = 1;
            @(posedge clk);
            we = 0;
            #2;
            re = 1;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write '0' and Read", test_num);
            reset_dut();

            @(posedge clk);
            d = 1; we = 1;
            @(posedge clk);

            d = 0; we = 1;
            @(posedge clk);
            we = 0;
            re = 1;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: WE Low Check", test_num);
            reset_dut();
            @(posedge clk);
            d = 1;
            we = 0;
            @(posedge clk);
            re = 1;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: WE and RE Low Maintenance Check", test_num);
            reset_dut();

            @(posedge clk);
            d = 1; we = 1;
            @(posedge clk);
            we = 0;

            re = 1;
            #10;

            re = 0;
            we = 0;
            d = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Asynchronous Reset Mid-operation", test_num);
            reset_dut();

            @(posedge clk);
            d = 1; we = 1;
            @(posedge clk);
            we = 0; re = 1;
            #5;
            rst = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Read Persistence Check", test_num);
            reset_dut();
            @(posedge clk);
            d = 1; we = 1;
            @(posedge clk);
            we = 0;
            re = 1;
            #5;
            d = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, d, re, rst, we, q);
    end

endmodule
