`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg re;
    reg we;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .clk(clk),
        .d(d),
        .re(re),
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
            @(negedge clk);
            we = 1;
            re = 0;
            d = 4'h0;
            @(negedge clk);
            we = 0;
            d = 4'h0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; re = 0; d = 4'hA;
            @(negedge clk);
            we = 0; re = 0;


            @(negedge clk);
            we = 0; re = 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting data", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; re = 0; d = 4'h5;
            @(negedge clk);


            we = 1; re = 0; d = 4'hC;
            @(negedge clk);
            we = 0;


            @(negedge clk);
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; re = 0; d = 4'hF;
            @(negedge clk);


            we = 0; re = 0; d = 4'h0;
            repeat(3) @(negedge clk);


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero data check", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; re = 0; d = 4'hF;
            @(negedge clk);


            we = 1; re = 0; d = 4'h0;
            @(negedge clk);
            we = 0; re = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; re = 0; d = 4'h5;
            @(negedge clk);


            we = 1; re = 0; d = 4'hA;
            @(negedge clk);


            we = 0; re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, d, re, we, q);
    end

endmodule
