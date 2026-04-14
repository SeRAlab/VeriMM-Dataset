`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg re;
    reg we;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .data(data),
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
            @(posedge clk);
            we <= 1;
            re <= 0;
            data <= 16'h0000;
            @(posedge clk);
            we <= 0;
            data <= 16'h0000;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1;
            data <= 16'hAAAA;
            @(posedge clk);
            we <= 0;


            re <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Integrity (All 1s)", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1;
            data <= 16'hFFFF;
            @(posedge clk);
            we <= 0;


            re <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Check", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1;
            data <= 16'h5555;
            @(posedge clk);


            we <= 0;
            data <= 16'hBBBB;
            @(posedge clk);


            re <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read Enable Check", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1;
            data <= 16'h1234;
            @(posedge clk);
            we <= 0;


            re <= 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Sequential Writes", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1; data <= 16'h1111;
            @(posedge clk);
            data <= 16'h2222;
            @(posedge clk);
            data <= 16'h3333;
            @(posedge clk);
            we <= 0;


            re <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(posedge clk);
            we <= 1; data <= 16'h7777;
            @(posedge clk);


            re <= 1;
            data <= 16'h8888;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h8888);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, data, re, we, q);
    end

endmodule
