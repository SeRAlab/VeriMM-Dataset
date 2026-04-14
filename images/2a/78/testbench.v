`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg re;
    reg we;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
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
            we <= 0;
            re <= 0;
            d  <= 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read (8'hA5)", test_num);


            d <= 8'hA5;
            we <= 1;
            @(posedge clk);
            #1;
            we <= 0;


            re <= 1;
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Data Retention", test_num);


            d <= 8'h5A;
            we <= 1;
            @(posedge clk);
            #1;
            we <= 0;


            repeat(3) @(posedge clk);


            re <= 1;
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Overwriting data", test_num);


            d <= 8'h11;
            we <= 1;
            @(posedge clk);
            #1;


            d <= 8'hEE;
            we <= 1;
            @(posedge clk);
            #1;
            we <= 0;


            re <= 1;
            #1;
            #1;

            check_outputs(8'hEE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value 8'hFF", test_num);

            d <= 8'hFF;
            we <= 1;
            @(posedge clk);
            #1;
            we <= 0;
            re <= 1;
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value 8'h00", test_num);

            d <= 8'h00;
            we <= 1;
            @(posedge clk);
            #1;
            we <= 0;
            re <= 1;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: WE ignore check", test_num);


            d <= 8'h33;
            we <= 1;
            @(posedge clk);
            #1;


            we <= 0;
            d <= 8'hCC;
            @(posedge clk);
            #1;


            re <= 1;
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Sequential Read/Write", test_num);

            d <= 8'h12; we <= 1; @(posedge clk); #1;
            d <= 8'h34; we <= 1; @(posedge clk); #1;
            we <= 0;
            re <= 1;
            #1;

            #1;


            check_outputs(8'h34);
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
        $dumpvars(0,clk, d, re, we, q);
    end

endmodule
